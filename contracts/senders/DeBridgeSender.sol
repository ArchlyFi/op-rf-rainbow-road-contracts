// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {Flags} from "../libraries/Flags.sol";
import {IDeBridgeGate} from "../interfaces/IDeBridgeGate.sol";
import {IDeBridgeGateExtended} from "../interfaces/IDeBridgeGateExtended.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IDeBridgeReceiver} from "../interfaces/IDeBridgeReceiver.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";

/**
 * Sends messages to the deBridge Gate
 */
contract DeBridgeSender is ArcBaseWithRainbowRoad 
{
    IDeBridgeGateExtended public gate;
    mapping(address => bool) public admins;

    event MessageSent(bytes32 submissionId, uint256 destinationChainSelector, address messageReceiver, string action, address actionRecipient);

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

    function send(uint256 destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused onlyAdmins returns (bytes32 submissionId)
    {
        return _send(destinationChainSelector, messageReceiver, actionRecipient, action, payload);
    }
    
    function send(uint256 destinationChainSelector, address messageReceiver, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused returns (bytes32 submissionId)
    {
        return _send(destinationChainSelector, messageReceiver, msg.sender, action, payload);
    }
    
    function getDeBridgeExecutionFee(string calldata action) external view returns (uint256)
    {
        IDeBridgeGate.SubmissionAutoParamsTo memory autoParams;
        bytes memory executionFee;
        {
            string memory executionFeeConfigName = 'debridge_sender.execution_fee';
            string memory executionFeeConfigNameOverride = string.concat(executionFeeConfigName, '_', action);
            executionFee = rainbowRoad.config(executionFeeConfigNameOverride);
            if(executionFee.length == 0) {
                executionFee = rainbowRoad.config(executionFeeConfigName);
            }
        }
        
        uint256 amountToSend = abi.decode(executionFee, (uint256));
        autoParams.executionFee = amountToSend * (10000 - gate.globalTransferFeeBps()) / 10000;
        
        return autoParams.executionFee;
    }
    
    function _send(uint256 destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) internal returns (bytes32 submissionId)
    {
        require(messageReceiver != address(0), 'Message receiver cannot be zero address');

        rainbowRoad.sendAction(action, actionRecipient, payload);
        
        IDeBridgeGate.SubmissionAutoParamsTo memory autoParams;
        bytes memory executionFee;
        {
            string memory executionFeeConfigName = 'debridge_sender.execution_fee';
            string memory executionFeeConfigNameOverride = string.concat(executionFeeConfigName, '_', action);
            executionFee = rainbowRoad.config(executionFeeConfigNameOverride);
            if(executionFee.length == 0) {
                executionFee = rainbowRoad.config(executionFeeConfigName);
            }
        }
        
        uint256 amountToSend = abi.decode(executionFee, (uint256));
        autoParams.executionFee = amountToSend * (10000 - gate.globalTransferFeeBps()) / 10000;
        
        autoParams.flags = Flags.setFlag(
            autoParams.flags,
            Flags.PROXY_WITH_SENDER,
            true
        );
        
        autoParams.flags = Flags.setFlag(
            autoParams.flags,
            Flags.REVERT_IF_EXTERNAL_FAIL,
            true
        );
        
        autoParams.data = abi.encodeWithSelector(IDeBridgeReceiver.dbReceive.selector, abi.encode(action, actionRecipient, payload));
        autoParams.fallbackAddress = abi.encodePacked(rainbowRoad.team());
        
        submissionId = gate.send{value: gate.globalFixedNativeFee() + amountToSend}(
            address(0), // _tokenAddress
            amountToSend, // _amount
            destinationChainSelector, // _chainIdTo
            abi.encodePacked(messageReceiver), // _receiver
            "", // _permit
            true, // _useAssetFee
            abi.decode(rainbowRoad.config('debridge_sender.referral_code'), (uint32)), // _referralCode
            abi.encode(autoParams) // _autoParams
        );
        
        emit MessageSent(submissionId, destinationChainSelector, messageReceiver, action, actionRecipient);
    }
    
    /// @dev Only calls from the enabled admins are accepted.
    modifier onlyAdmins() 
    {
        require(admins[msg.sender], 'Invalid admin');
        _;
    }

    receive() external payable {}
}
