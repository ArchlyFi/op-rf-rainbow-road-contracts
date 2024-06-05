// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface IDeBridgeReceiver {
    function dbReceive(bytes calldata message) external;
}