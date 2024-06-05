// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {MessageClient} from "@cryptolink/contracts/message/MessageClient.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";

/**
 * Sends messages to the CryptoLink Message System
 */
contract CryptoLinkSender is ArcBaseWithRainbowRoad, MessageClient
{
    mapping(address => bool) public admins;

    event MessageSent(uint transactionId, uint destinationChainSelector, address messageReceiver, string action, address actionRecipient);

    constructor(address _rainbowRoad) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
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

    function send(uint destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused onlyAdmins returns (uint transactionId)
    {
        return _send(destinationChainSelector, messageReceiver, actionRecipient, action, payload);
    }
    
    function send(uint destinationChainSelector, address messageReceiver, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused returns (uint transactionId)
    {
        return _send(destinationChainSelector, messageReceiver, msg.sender, action, payload);
    }
    
    function _send(uint destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) internal returns (uint transactionId)
    {
        require(messageReceiver != address(0), 'Message receiver cannot be zero address');

        rainbowRoad.sendAction(action, actionRecipient, payload);
        
        transactionId = _sendMessage(
            destinationChainSelector,
            abi.encode(action, actionRecipient, payload)
        );
        
        emit MessageSent(transactionId, destinationChainSelector, messageReceiver, action, actionRecipient);
    }
    
    /// @dev Only calls from the enabled admins are accepted.
    modifier onlyAdmins() 
    {
        require(admins[msg.sender], 'Invalid admin');
        _;
    }
}
