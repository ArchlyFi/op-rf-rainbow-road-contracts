// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface IMinter {
    function update_period() external returns (uint);
}