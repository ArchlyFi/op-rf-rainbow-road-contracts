// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {IAxelarGasService} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import {IAxelarGateway} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import {AddressToString} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/libs/AddressString.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";

/**
 * Sends messages to the Axelar Gateway
 */
contract AxelarSender is ArcBaseWithRainbowRoad 
{
    using AddressToString for address;
    
    enum PaymentTypes {
        NATIVE,
        TOKEN
    }
    
    IAxelarGateway public gateway;
    IAxelarGasService public gasService;
    PaymentTypes public paymentType;
    IERC20 public paymentToken;
    mapping(address => bool) public admins;

    event MessageSent(string destinationChainSelector, address messageReceiver, string action, address actionRecipient);

    constructor(address _rainbowRoad, address _gateway, address _gasService, address _paymentToken) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
        require(_gateway != address(0), 'Gateway cannot be zero address');
        require(_gasService != address(0), 'Gas service cannot be zero address');
        require(_paymentToken != address(0), 'Payment token cannot be zero address');
        
        gateway = IAxelarGateway(_gateway);
        gasService = IAxelarGasService(_gasService);
        paymentType = PaymentTypes.NATIVE;
        paymentToken = IERC20(_paymentToken);
    }
    
    function setGateway(address _gateway) external onlyOwner
    {
        require(_gateway != address(0), 'Gateway cannot be zero address');
        gateway = IAxelarGateway(_gateway);
    }
    
    function setGasService(address _gasService) external onlyOwner
    {
        require(_gasService != address(0), 'Gas service cannot be zero address');
        gasService = IAxelarGasService(_gasService);
    }

    function setPaymentToken(address _paymentToken) external onlyOwner
    {
        require(_paymentToken != address(0), 'Payment token cannot be zero address');
        paymentToken = IERC20(_paymentToken);
    }
    
    function setPaymentTypeToToken() external onlyOwner
    {
        require(paymentType != PaymentTypes.TOKEN, 'Fees are already paid in TOKEN');
        paymentType = PaymentTypes.TOKEN;
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

    function send(string calldata destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused onlyAdmins
    {
        return _send(destinationChainSelector, messageReceiver, actionRecipient, action, payload);
    }
    
    function send(string calldata destinationChainSelector, address messageReceiver, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused
    {
        return _send(destinationChainSelector, messageReceiver, msg.sender, action, payload);
    }

    function _send(string calldata destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) internal
    {
        require(messageReceiver != address(0), 'Message receiver cannot be zero address');

        rainbowRoad.sendAction(action, actionRecipient, payload);
        
        bytes memory message = abi.encode(action, actionRecipient, payload);
        string memory destinationAddress = messageReceiver.toString();

        if (paymentType == PaymentTypes.TOKEN) {
            
            uint256 tokenFee;
            {
                string memory tokenFeeConfigName = 'axelar_sender.token_fee';
                string memory tokenFeeConfigNameOverride = string.concat(tokenFeeConfigName, '_', action);
                bytes memory tokenFeeConfig = rainbowRoad.config(tokenFeeConfigNameOverride);
                
                if(tokenFeeConfig.length == 0) {
                    tokenFeeConfig = rainbowRoad.config(tokenFeeConfigName);
                }
                
                tokenFee = abi.decode(tokenFeeConfig, (uint256));
            }
            
            paymentToken.approve(address(gasService), tokenFee);
            gasService.payGasForContractCall(
                address(this),
                destinationChainSelector,
                destinationAddress,
                message,
                address(paymentToken),
                tokenFee,
                address(this)
            );
            
            gateway.callContract(destinationChainSelector, destinationAddress, message);
        } else {
            
            uint256 nativeFee;
            {
                string memory nativeFeeConfigName = 'axelar_sender.native_fee';
                string memory nativeFeeConfigNameOverride = string.concat(nativeFeeConfigName, '_', action);
                bytes memory nativeFeeConfig = rainbowRoad.config(nativeFeeConfigNameOverride);
                
                if(nativeFeeConfig.length == 0) {
                    nativeFeeConfig = rainbowRoad.config(nativeFeeConfigName);
                }
                
                nativeFee = abi.decode(nativeFeeConfig, (uint256));
            }
            
            gasService.payNativeGasForContractCall{ value: nativeFee }(
                address(this),
                destinationChainSelector,
                destinationAddress,
                message,
                address(this)
            );
            
            gateway.callContract(destinationChainSelector, destinationAddress, message);
        }

        emit MessageSent(destinationChainSelector, messageReceiver, action, actionRecipient);
    }
    
    /// @dev Only calls from the enabled admins are accepted.
    modifier onlyAdmins() 
    {
        require(admins[msg.sender], 'Invalid admin');
        _;
    }

    receive() external payable {}
}
