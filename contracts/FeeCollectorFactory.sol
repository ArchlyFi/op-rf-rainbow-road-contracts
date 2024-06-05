// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import {FeeCollector} from './FeeCollector.sol';

contract FeeCollectorFactory {
    address public last_fee_collector;

    function createFeeCollector(address rainbowRoad, address authorizedAccount) external returns (address) {
        
        FeeCollector feeCollector = new FeeCollector(rainbowRoad, authorizedAccount);
        last_fee_collector = address(feeCollector);
        return last_fee_collector;
    }
}
