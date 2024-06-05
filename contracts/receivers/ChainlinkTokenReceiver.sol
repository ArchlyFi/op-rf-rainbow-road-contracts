// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";

/**
 * Receives messages from Chainlink CCIP Token router
 */
contract ChainlinkTokenReceiver is ArcBaseWithRainbowRoad, CCIPReceiver 
{
    using SafeERC20 for IERC20;
    
    mapping(uint64 => mapping(address => bool)) public messageSenders;
    
    event MessageReceived(bytes32 messageId, uint64 sourceChainSelector, address messageSender, string action, address actionRecipient);

    constructor(address _rainbowRoad, address _router) CCIPReceiver(_router) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
    }
    
    function enableMessageSender(uint64 sourceChainSelector, address messageSender) external onlyOwner
    {
        require(!messageSenders[sourceChainSelector][messageSender], 'ChainlinkTokenReceiver: Message sender for source chain is enabled');
        messageSenders[sourceChainSelector][messageSender] = true;
    }
    
    function disableMessageSender(uint64 sourceChainSelector, address messageSender) external onlyOwner
    {
        require(messageSenders[sourceChainSelector][messageSender], 'ChainlinkTokenReceiver: Message sender for source chain is disabled');
        messageSenders[sourceChainSelector][messageSender] = false;
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override
    {
        _requireNotPaused();
        
        bytes32 messageId = message.messageId;
        uint64 sourceChainSelector = message.sourceChainSelector;
        address messageSender = abi.decode(message.sender, (address));
        require(messageSenders[sourceChainSelector][messageSender], 'ChainlinkTokenReceiver: Unsupported source chain/message sender');
        
        (string memory action, address actionRecipient, bytes memory payload) = abi.decode(message.data, (string, address, bytes));
        
        (string memory tokenSymbol, uint256 amount) = abi.decode(payload, (string, uint256));
        address tokenAddress = rainbowRoad.tokens(tokenSymbol);
        require(tokenAddress != address(0), 'ChainlinkTokenReceiver: Token must be whitelisted');
        require(!rainbowRoad.blockedTokens(tokenAddress), 'ChainlinkTokenReceiver: Token is blocked');
        
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, 'ChainlinkTokenReceiver: Insufficient token amount received');
        
        address actionHandlerAddress = rainbowRoad.actionHandlers(action);
        require(actionHandlerAddress != address(0), 'ChainlinkTokenReceiver: Action handler not found');
        token.safeTransfer(actionHandlerAddress, amount);

        rainbowRoad.receiveAction(action, actionRecipient, payload);

        emit MessageReceived(messageId, sourceChainSelector, messageSender, action, actionRecipient);
    }

    receive() external payable {}
}
