// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";

/**
 * Sends messages to the Chainlink CCIP router
 */
contract ChainlinkTokenSender is ArcBaseWithRainbowRoad 
{
    using SafeERC20 for IERC20;
    
    enum PaymentTypes {
        NATIVE,
        LINK
    }

    IRouterClient public router;
    LinkTokenInterface public link;
    PaymentTypes public paymentType;
    mapping(address => bool) public admins;

    event MessageSent(bytes32 messageId, uint64 destinationChainSelector, address messageReceiver, string action, address actionRecipient);

    constructor(address _rainbowRoad, address _router, address _link) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
        require(_router != address(0), 'Router cannot be zero address');
        require(_link != address(0), 'Link cannot be zero address');
        
        router = IRouterClient(_router);
        link = LinkTokenInterface(_link);
        paymentType = PaymentTypes.LINK;
    }
    
    function setRouter(address _router) external onlyOwner
    {
        require(_router != address(0), 'Router cannot be zero address');
        router = IRouterClient(_router);
    }

    function setLink(address _link) external onlyOwner
    {
        require(_link != address(0), 'Link cannot be zero address');
        link = LinkTokenInterface(_link);
    }
    
    function setPaymentTypeToLink() external onlyOwner
    {
        require(paymentType != PaymentTypes.LINK, 'Fees are already paid in LINK');
        paymentType = PaymentTypes.LINK;
    }
    
    function setPaymentTypeToNative() external onlyOwner
    {
        require(paymentType != PaymentTypes.NATIVE, 'Fees are already paid in NATIVE');
        paymentType = PaymentTypes.NATIVE;
    }
    
    function enableAdmin(address admin) external onlyOwner
    {
        require(!admins[admin], 'Admin is enabled');
        admins[admin] = true;
    }
    
    function disableAdmin(address admin) external onlyOwner
    {
        require(admins[admin], 'Admin is disabled');
        admins[admin] = false;
    }

    function send(uint64 destinationChainSelector, address messageReceiver, address actionRecipient, bytes calldata payload) external nonReentrant whenNotPaused onlyAdmins returns (bytes32 messageId)
    {
        return _send(destinationChainSelector, messageReceiver, actionRecipient, 'chainlink_token_transfer', payload);
    }
    
    function send(uint64 destinationChainSelector, address messageReceiver, bytes calldata payload) external nonReentrant whenNotPaused returns (bytes32 messageId)
    {
        return _send(destinationChainSelector, messageReceiver, msg.sender, 'chainlink_token_transfer', payload);
    }

    function _send(uint64 destinationChainSelector, address messageReceiver, address actionRecipient, string memory action, bytes calldata payload) internal returns (bytes32 messageId)
    {
        require(messageReceiver != address(0), 'Message receiver cannot be zero address');

        rainbowRoad.sendAction(action, actionRecipient, payload);
        
        Client.EVM2AnyMessage memory message;
        uint256 fee;
        {
            (string memory tokenSymbol, uint256 amount, uint256 feeOnTransferAmount) = abi.decode(payload, (string, uint256, uint256));
            IERC20 token = IERC20(rainbowRoad.tokens(tokenSymbol));
            require(address(token) != address(0), 'ChainlinkTokenSender: Token must be whitelisted');
            require(!rainbowRoad.blockedTokens(address(token)), 'ChainlinkTokenSender: Token is blocked');
            
            require(token.balanceOf(actionRecipient) >= amount + feeOnTransferAmount, 'ChainlinkTokenSender: Insufficient token balance for message sender');
            token.safeTransferFrom(actionRecipient, address(this), amount + feeOnTransferAmount);
            
            require(token.balanceOf(address(this)) >= amount, 'ChainlinkTokenSender: Insufficient token amount received');
            token.approve(address(router), amount);
            
            message = getTokenTransferMessage(messageReceiver, actionRecipient, action, payload, address(token), amount);
            fee = router.getFee(destinationChainSelector, message);
        }
        
        if (paymentType == PaymentTypes.LINK) {
            link.approve(address(router), fee);
            messageId = router.ccipSend(destinationChainSelector, message);
        } else {
            messageId = router.ccipSend{value: fee}(destinationChainSelector, message);
        }

        emit MessageSent(messageId, destinationChainSelector, messageReceiver, action, actionRecipient);
    }
    
    function getTokenTransferMessage(address messageReceiver, address actionRecipient, string memory action, bytes calldata payload, address tokenAddress, uint256 amount) private view returns (Client.EVM2AnyMessage memory message) {
        bytes memory extraArgs;
        {
            string memory extraArgsConfigName = 'chainlink_sender_v1_2_0.extra_args';
            string memory extraArgsConfigNameOverride = string.concat(extraArgsConfigName, '_', action);
            extraArgs = rainbowRoad.config(extraArgsConfigNameOverride);
            if(extraArgs.length == 0) {
                extraArgs = rainbowRoad.config(extraArgsConfigName);
            }
        }
            
        Client.EVMTokenAmount[] memory tokenAmounts = new Client.EVMTokenAmount[](1);
        tokenAmounts[0] = Client.EVMTokenAmount({
            token: tokenAddress,
            amount: amount
        });
        
        message = Client.EVM2AnyMessage({
            receiver: abi.encode(messageReceiver),
            data: abi.encode(action, actionRecipient, payload),
            tokenAmounts: tokenAmounts,
            extraArgs: extraArgs,
            feeToken: paymentType == PaymentTypes.LINK ? address(link) : address(0)
        });
    }
    
    /// @dev Only calls from the enabled admins are accepted.
    modifier onlyAdmins() 
    {
        require(admins[msg.sender], 'Invalid admin');
        _;
    }

    receive() external payable {}
}
