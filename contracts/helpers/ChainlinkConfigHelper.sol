// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

/**
 * Helps configures Chainlink contracts
 */
contract ChainlinkConfigHelper
{
    function encodeEvmExtraArgsV1(uint256 gasLimit) external pure returns (bytes memory)
    {
        return Client._argsToBytes(
            // Additional arguments, setting gas limit and non-strict sequencing mode
            Client.EVMExtraArgsV1({gasLimit: gasLimit})
        );
    }
}