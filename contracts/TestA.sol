// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestA {

    uint256 public amount;

    constructor(){}

    function addInt(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function addAmount() public {
        amount += 1;
    }

    function getAmount() public view returns (uint256) {
        return amount;
    }
}
