// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IHandler} from "../interfaces/IHandler.sol";

/**
 * Chainlink Token Transfer Handler
 */
contract ChainlinkTokenTransferHandler is ArcBaseWithRainbowRoad, IHandler
{
    using SafeERC20 for IERC20;
    
    constructor(address _rainbowRoad) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
    }
    
    function encodePayload(string calldata tokenSymbol, uint256 amount) view external returns (bytes memory payload)
    {
        address tokenAddress = rainbowRoad.tokens(tokenSymbol);
        require(tokenAddress != address(0), 'Token must be whitelisted');
        require(!rainbowRoad.blockedTokens(tokenAddress), 'Token is blocked');
        require(amount > 0, 'Invalid amount');
        require(isTokenTransferEnabled(tokenSymbol), 'ChainlinkTokenTransferHandler: Token transfer not enabled');
        
        uint256 amountToSend = amount;
        
        string memory feeOnTransferPercentageRateConfigName = string.concat('token.fee_on_transfer_pct.', tokenSymbol);
        uint256 feeOnTransferPercentageRate = abi.decode(rainbowRoad.config(feeOnTransferPercentageRateConfigName), (uint256));
        if(feeOnTransferPercentageRate > 0) {
            uint256 transferFee = (feeOnTransferPercentageRate * amount) / 1000;
            require(amountToSend > transferFee, 'Insufficient amount to send : Percent Rate');
            amountToSend = amountToSend - transferFee;
        }
        
        string memory feeOnTransferFlatRateConfigName = string.concat('token.fee_on_transfer_flat.', tokenSymbol);
        uint256 feeOnTransferFlatRate = abi.decode(rainbowRoad.config(feeOnTransferFlatRateConfigName), (uint256));
        if(feeOnTransferFlatRate > 0) {
            require(amountToSend > feeOnTransferFlatRate, 'Insufficient amount to send : Flat Rate');
            amountToSend = amountToSend - feeOnTransferFlatRate;
        }
        
        return abi.encode(tokenSymbol, amountToSend, amount - amountToSend);
    }
    
    function handleReceive(address target, bytes calldata payload) external onlyRainbowRoad whenNotPaused nonReentrant
    {
        (string memory tokenSymbol, uint256 amount) = abi.decode(payload, (string, uint256));
        require(amount > 0, 'Invalid amount');
        require(isTokenTransferEnabled(tokenSymbol), 'ChainlinkTokenTransferHandler: Token transfer not enabled');
        
        address tokenAddress = rainbowRoad.tokens(tokenSymbol);
        
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, 'ChainlinkTokenTransferHandler: Insufficient funds for transfer');
        
        token.safeTransfer(target, amount);
    }
    
    function handleSend(address /*target*/, bytes calldata payload) external onlyRainbowRoad whenNotPaused nonReentrant
    {
        (string memory tokenSymbol, uint256 amount) = abi.decode(payload, (string, uint256));
        require(amount > 0, 'ChainlinkTokenTransferHandler: Invalid amount');
        require(isTokenTransferEnabled(tokenSymbol), 'ChainlinkTokenTransferHandler: Token transfer not enabled');
    }
    
    function isTokenTransferEnabled(string memory tokenSymbol) private view returns (bool)
    {
        string memory chainlinkTokenTransferEnabledConfigName = string.concat('token.chainlink_token_transfer_enabled.', tokenSymbol);
        return abi.decode(rainbowRoad.config(chainlinkTokenTransferEnabledConfigName), (bool));
    }
}