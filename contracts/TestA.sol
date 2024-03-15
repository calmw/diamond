// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestA {
    uint256 public amount;

    uint256 public amount2;

    constructor() {}

    function addInt(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function addAmount() public {
        amount += 1;
    }

    function addAmount2() public {
        amount2 += 2;
    }

    function getAmount() public view returns (uint256) {
        return amount;
    }

    function getAmount2() public view returns (uint256) {
        return amount2;
    }
}
