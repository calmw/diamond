// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestB {
    uint256 public num;
    uint256 private amountB;

    constructor() {}

    function addAmountB() public {
        amountB += 1;
    }

    function addNum() public {
        num += 10;
    }

}
