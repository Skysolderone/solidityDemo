// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library priceInfo{
     function getPrice()internal  view returns(uint256) {
        //abi
        //address 0x694AA1769357215DE4FAC081bf1f309aDC325306 eth/usd
        AggregatorV3Interface priInfo=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,)=priInfo.latestRoundData();
        return uint256(price*1e10);
    }
    function getConversionRate(uint256 ethamount)internal view returns (uint256) {
        uint256 hasmoney=getPrice();
        uint256 result=(hasmoney*ethamount)/1e18;
        return result;
    } 
}