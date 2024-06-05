// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {AxelarExecutable} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import {IAxelarGateway} from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import {StringToAddress} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/libs/AddressString.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IRainbowRoad} from "../interfaces/IRainbowRoad.sol";

/**
 * Receives messages from the Axelar Gateway
 */
contract AxelarReceiver is ArcBaseWithRainbowRoad, AxelarExecutable 
{
    using StringToAddress for string;
    
    mapping(string => mapping(address => bool)) public messageSenders;
    
    event MessageReceived(string sourceChainSelector, address messageSender, string action, address actionRecipient);

    constructor(address _rainbowRoad, address _gateway) AxelarExecutable(_gateway) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
    }
    
    function enableMessageSender(string calldata sourceChainSelector, address messageSender) external onlyOwner
    {
        require(!messageSenders[sourceChainSelector][messageSender], 'Message sender for source chain is enabled');
        messageSenders[sourceChainSelector][messageSender] = true;
    }
    
    function disableMessageSender(string calldata sourceChainSelector, address messageSender) external onlyOwner
    {
        require(messageSenders[sourceChainSelector][messageSender], 'Message sender for source chain is disabled');
        messageSenders[sourceChainSelector][messageSender] = false;
    }

    function _execute(string calldata sourceChainSelector, string calldata sourceAddress, bytes calldata message) internal override
    {
        _requireNotPaused();
        
        address messageSender = sourceAddress.toAddress();
        require(messageSenders[sourceChainSelector][messageSender], 'Unsupported source chain/message sender');
        
        (string memory action, address actionRecipient, bytes memory payload) = abi.decode(message, (string, address, bytes));

        rainbowRoad.receiveAction(action, actionRecipient, payload);

        emit MessageReceived(sourceChainSelector, messageSender, action, actionRecipient);
    }

    receive() external payable {}
}
