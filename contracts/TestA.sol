// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestA {
    uint256 public amount;

    uint256 public amount2;

    constructor() {}

    function addAmount() public {
        amount += 1;
    }

    function addAmount2() public {
        amount2 += 2;
    }

}
