// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface IAdminChainlinkSender {
    function send(uint64 destinationChainSelector, address messageReceiver, address actionRecipient, string calldata action, bytes calldata payload) external;
    function send(uint64 destinationChainSelector, address messageReceiver, string calldata action, bytes calldata payload) external;
}