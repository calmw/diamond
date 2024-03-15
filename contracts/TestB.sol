// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface A {
    function getAmount() external view returns (uint256);
}

contract TestB {
    uint256 public num;

    constructor() {}


    function addNum() public {
        num += 10;
    }

    function getAamount() public view returns (uint256) {
        return A(0x4fB55EA66C026aAA8c36C6FBd5837eBF495d6841).getAmount();
    }

}
