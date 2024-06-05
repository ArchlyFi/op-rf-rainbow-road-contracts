// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {ArcBaseWithRainbowRoad} from "../bases/ArcBaseWithRainbowRoad.sol";
import {IHandler} from "../interfaces/IHandler.sol";
import {IMinter} from "../interfaces/IMinter.sol";

/**
 * Dex Weekly Update Handler
 */
contract DexWeeklyUpdateHandler is ArcBaseWithRainbowRoad, IHandler
{
    IMinter public minter;
    
    event PeriodUpdatedSucccessfully(address target, bytes payload, uint period, uint256 timestamp);
    
    constructor(address _rainbowRoad, address _minter) ArcBaseWithRainbowRoad(_rainbowRoad)
    {
        require(_minter != address(0), 'Minter cannot be zero address');
        
        minter = IMinter(_minter);
        _transferOwnership(rainbowRoad.team());
    }
    
    function encodePayload() pure external returns (bytes memory payload)
    {
        return '';
    }
    
    function setMinter(address _minter) external onlyOwner
    {
        require(_minter != address(0), 'Minter cannot be zero address');
        minter = IMinter(_minter);
    }
    
    function handleSend(address target, bytes calldata payload) external view onlyRainbowRoad whenNotPaused
    {
        require(target != address(0), 'Target cannot be zero address');
        require(payload.length == 0, 'Invalid payload');
    }
    
    function handleReceive(address target, bytes calldata payload) external onlyRainbowRoad whenNotPaused
    {
        require(target != address(0), 'Target cannot be zero address');
        require(payload.length == 0, 'Invalid payload');
        uint period = minter.update_period();
        emit PeriodUpdatedSucccessfully(target, payload, period, block.timestamp);
    }
}