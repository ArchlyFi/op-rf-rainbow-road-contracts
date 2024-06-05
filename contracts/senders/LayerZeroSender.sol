// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {ILayerZeroEndpoint} from "../interfaces/ILayerZeroEndpoint.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";

/**
 * Sends messages to the LayerZero endpoint
 */
contract LayerZeroSender is ArcBaseWithRainbowRoad 
{
    enum PaymentTypes {
        NATIVE,
        ZRO
    }

    ILayerZeroEndpoint public endpoint;
    PaymentTypes public paymentType;
    address public zroToken;
    mapping(address => bool) public admins;

    event MessageSent(uint64 destinationChainSelector, bytes trustedRemote, string action, address actionRecipient);

    constructor(address _rainbowRoad, address _endpoint) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
        require(_endpoint != address(0), 'LayerZero endpoint cannot be zero address');
        endpoint = ILayerZeroEndpoint(_endpoint);
        paymentType = PaymentTypes.NATIVE;
        zroToken = address(0);
    }
    
    function setZroToken(address _zroToken) external onlyOwner
    {
        require(_zroToken != address(0), 'ZRO token cannot be zero address');
        zroToken = _zroToken;
    }
    
    function setEndpoint(address _endpoint) external onlyOwner
    {
        require(_endpoint != address(0), 'LayerZero endpoint cannot be zero address');
        endpoint = ILayerZeroEndpoint(_endpoint);
    }
    
    function setPaymentTypeToZro() external onlyOwner
    {
        require(paymentType != PaymentTypes.ZRO, 'Fees are already paid in ZRO');
        paymentType = PaymentTypes.ZRO;
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

    function send(uint16 destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused onlyAdmins
    {
        return _send(destinationChainSelector, messageReceiver, actionRecipient, action, payload);
    }
    
    function send(uint16 destinationChainSelector, address messageReceiver, string calldata action, bytes calldata payload) external nonReentrant whenNotPaused
    {
        return _send(destinationChainSelector, messageReceiver, msg.sender, action, payload);
    }

    function _send(uint16 destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) internal
    {
        require(messageReceiver != address(0), 'Message receiver cannot be zero address');

        rainbowRoad.sendAction(action, actionRecipient, payload);
        
        bytes memory adapterParams;
        {
            string memory adapterParamsConfigName = 'layerzero_sender.adapter_params';
            string memory adapterParamsConfigNameOverride = string.concat(adapterParamsConfigName, '_', action);
            adapterParams = rainbowRoad.config(adapterParamsConfigNameOverride);
            if(adapterParams.length == 0) {
                adapterParams = rainbowRoad.config(adapterParamsConfigName);
            }
        }
        
        bytes memory message = abi.encode(action, actionRecipient, payload);
        bytes memory trustedRemote = abi.encodePacked(messageReceiver, address(this));
        
        (uint nativeFee, uint zroFee) = endpoint.estimateFees(
            destinationChainSelector,
            address(this),
            message,
            paymentType == PaymentTypes.ZRO,
            adapterParams
        );
        
        if (paymentType == PaymentTypes.ZRO) {
            
            IERC20(zroToken).approve(address(endpoint), zroFee);
            
            endpoint.send(
                destinationChainSelector,
                trustedRemote,
                message,
                payable(this),
                address(this),
                adapterParams
            );
        } else {
            
            endpoint.send{value: nativeFee}(
                destinationChainSelector,
                trustedRemote,
                message,
                payable(this),
                address(0),
                adapterParams
            );
        }

        emit MessageSent(destinationChainSelector, trustedRemote, action, actionRecipient);
    }
    
    /// @dev Only calls from the enabled admins are accepted.
    modifier onlyAdmins() 
    {
        require(admins[msg.sender], 'Invalid admin');
        _;
    }

    receive() external payable {}
}
