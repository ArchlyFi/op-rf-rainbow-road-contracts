// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

/**
 * Helps configures DeBridge contracts
 */
contract DeBridgeConfigHelper
{
    function encodeSenderAddress(address sender) external pure returns (bytes memory)
    {
        return abi.encodePacked(sender);
    }
    
    function encodeExecutionFee(uint256 gasFee) external pure returns (bytes memory)
    {
        return abi.encode(gasFee);
    }
    
    function encodeReferralCode(uint32 referralCode) external pure returns (bytes memory)
    {
        return abi.encode(referralCode);
    }
}