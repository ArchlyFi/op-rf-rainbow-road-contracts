// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

/**
 * Helps configures Axelar contracts
 */
contract AxelarConfigHelper
{
    function encodeGasFee(uint256 gasFee) external pure returns (bytes memory)
    {
        return abi.encode(gasFee);
    }
}