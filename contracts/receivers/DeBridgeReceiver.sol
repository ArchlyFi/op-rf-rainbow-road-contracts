// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";
import {IDeBridgeGateExtended} from "../interfaces/IDeBridgeGateExtended.sol";
import {ICallProxy} from "../interfaces/ICallProxy.sol";
import {IDeBridgeReceiver} from "../interfaces/IDeBridgeReceiver.sol";

/**
 * Receives messages from deBridge Gate
 */
contract DeBridgeReceiver is ArcBaseWithRainbowRoad, IDeBridgeReceiver 
{
    IDeBridgeGateExtended public gate;
    mapping(uint256 => mapping(bytes => bool)) public messageSenders;
    mapping(uint256 => bytes) public trustedRemoteLookup;
    
    event MessageReceived(uint256 sourceChainSelector, bytes messageSender, string action, address actionRecipient);

    constructor(address _rainbowRoad, address _gate) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
        require(_gate != address(0), 'deBridge gate cannot be zero address');
        gate = IDeBridgeGateExtended(_gate);
    }
    
    function setGate(address _gate) external onlyOwner
    {
        require(_gate != address(0), 'deBridge gate cannot be zero address');
        gate = IDeBridgeGateExtended(_gate);
    }
    
    function enableMessageSender(uint256 sourceChainSelector, bytes calldata messageSender) external onlyOwner
    {
        require(!messageSenders[sourceChainSelector][messageSender], 'Message sender for source chain is enabled');
        messageSenders[sourceChainSelector][messageSender] = true;
        trustedRemoteLookup[sourceChainSelector] = messageSender;
    }
    
    function disableMessageSender(uint256 sourceChainSelector, bytes calldata messageSender) external onlyOwner
    {
        require(messageSenders[sourceChainSelector][messageSender], 'Message sender for source chain is disabled');
        messageSenders[sourceChainSelector][messageSender] = false;
        delete trustedRemoteLookup[sourceChainSelector];
    }
    
    function dbReceive(bytes calldata message) external
    {
        _requireNotPaused();
        
        ICallProxy callProxy = ICallProxy(gate.callProxy());
        require(msg.sender == address(callProxy), 'Unsupported call proxy');
        
        uint256 sourceChainSelector = callProxy.submissionChainIdFrom();
        bytes memory messageSender = callProxy.submissionNativeSender();
        bytes memory trustedRemote = trustedRemoteLookup[sourceChainSelector];
        
        // Choose one of the two require statements below
        require(
            trustedRemote.length > 0 && messageSender.length > 0 && keccak256(messageSender) == keccak256(trustedRemote) && messageSenders[sourceChainSelector][messageSender],
            "Unsupported source chain/message sender"
        );
        
        (string memory action, address actionRecipient, bytes memory payload) = abi.decode(message, (string, address, bytes));

        rainbowRoad.receiveAction(action, actionRecipient, payload);

        emit MessageReceived(sourceChainSelector, messageSender, action, actionRecipient);
    }
    
    receive() external payable {}
}
