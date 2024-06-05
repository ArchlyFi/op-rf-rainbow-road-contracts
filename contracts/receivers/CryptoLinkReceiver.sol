// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";
import {MessageClient} from "@cryptolink/contracts/message/MessageClient.sol";

/**
 * Receives messages from CryptoLink Message System
 */
contract CryptoLinkReceiver is ArcBaseWithRainbowRoad, MessageClient 
{
    mapping(uint => mapping(address => bool)) public messageSenders;
    mapping(uint => mapping(address => mapping(uint => bytes32))) public failedMessages;
    
    event MessageReceived(uint transactionId, uint sourceChainSelector, address messageSender, address messageReference, uint amount, string action, address actionRecipient);
    event MessageFailed(uint sourceChainSelector, address sourceAddress, uint transactionId, address messageReference, uint amount, bytes payload);
    event RetryMessageSuccess(uint sourceChainSelector, address sourceAddress, uint transactionId, address messageReference, uint amount, bytes32 payloadHash);
    event RetryMessageAdded(uint sourceChainSelector, address sourceAddress, uint transactionId, address messageReference, uint amount, bytes payload);
    event RetryMessageRemoved(uint sourceChainSelector, address sourceAddress, uint transactionId, address messageReference, uint amount, bytes payload);

    constructor(address _rainbowRoad, address _messageSystem) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
        require(_messageSystem != address(0), 'CryptoLink message system cannot be zero address');
        _configureMessageV3(_messageSystem);
    }
    
    function setMessageSystem(address _messageSystem) external onlyOwner
    {
        require(_messageSystem != address(0), 'CryptoLink message system cannot be zero address');
        _configureMessageV3(_messageSystem);
    }
    
    function enableMessageSender(uint256 sourceChainSelector, address messageSender) external onlyOwner
    {
        require(!messageSenders[sourceChainSelector][messageSender], 'Message sender for source chain is enabled');
        messageSenders[sourceChainSelector][messageSender] = true;
    }
    
    function disableMessageSender(uint256 sourceChainSelector, address messageSender) external onlyOwner
    {
        require(messageSenders[sourceChainSelector][messageSender], 'Message sender for source chain is disabled');
        messageSenders[sourceChainSelector][messageSender] = false;
    }
    
    function messageProcess(uint _txId, uint _sourceChainId, address _sender, address _reference, uint _amount, bytes calldata _data) external virtual override whenNotPaused
    {
        require(msg.sender == address(MESSAGEv3), "Invalid message system caller");
        require(messageSenders[_sourceChainId][_sender], "Unsupported source chain/message sender");
        
        try this.handleReceive(_txId, _sourceChainId, _sender, _reference, _amount, _data) {
            
        } catch {
            failedMessages[_sourceChainId][_sender][_txId] = keccak256(abi.encode(_reference, _amount, _data));
            emit MessageFailed(_sourceChainId, _sender, _txId, _reference, _amount, _data);
        }
    }
    
    function handleReceive(uint _txId, uint _sourceChainId, address _sender, address _reference, uint _amount, bytes calldata _data) public 
    {
        require(msg.sender == address(this), "Invalid caller");
        
        (string memory action, address actionRecipient, bytes memory payload) = abi.decode(_data, (string, address, bytes));

        rainbowRoad.receiveAction(action, actionRecipient, payload);
        
        emit MessageReceived(_txId, _sourceChainId, _sender, _reference, _amount, action, actionRecipient);
    }
    
    function retryMessage(uint _txId, uint _sourceChainId, address _sender, address _reference, uint _amount, bytes calldata _data) public virtual 
    {
        // assert there is message to retry
        bytes32 payloadHash = failedMessages[_sourceChainId][_sender][_txId];
        require(payloadHash != bytes32(0), "Message not found");
        require(keccak256(abi.encode(_reference, _amount, _data)) == payloadHash, "Invalid payload");
        
        // clear the stored message
        delete failedMessages[_sourceChainId][_sender][_txId];
        
        // execute the message. revert if it fails again
        this.handleReceive(_txId, _sourceChainId, _sender, _reference, _amount, _data);
        emit RetryMessageSuccess(_sourceChainId, _sender, _txId, _reference, _amount, payloadHash);
    }
    
    function addRetryMessage(uint _txId, uint _sourceChainId, address _sender, address _reference, uint _amount, bytes calldata _data) public virtual onlyOwner
    {
        failedMessages[_sourceChainId][_sender][_txId] = keccak256(abi.encode(_reference, _amount, _data));
        emit RetryMessageAdded(_sourceChainId, _sender, _txId, _reference, _amount, _data);
    }
    
    function removeRetryMessage(uint _txId, uint _sourceChainId, address _sender, address _reference, uint _amount, bytes calldata _data) public virtual onlyOwner
    {
        // assert there is message to retry
        bytes32 payloadHash = failedMessages[_sourceChainId][_sender][_txId];
        require(payloadHash != bytes32(0), "Message not found");
        require(keccak256(abi.encode(_reference, _amount, _data)) == payloadHash, "Invalid payload");
        
        delete failedMessages[_sourceChainId][_sender][_txId];
        emit RetryMessageRemoved(_sourceChainId, _sender, _txId, _reference, _amount, _data);
    }
}
