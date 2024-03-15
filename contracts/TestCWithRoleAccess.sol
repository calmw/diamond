// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IRoleAccess} from "./interfaces/IRoleAccess.sol";

contract TestCWithRoleAccess {
    bytes32 public constant GENERAL_ADMIN_ROLE =
        keccak256("GENERAL_ADMIN_ROLE"); // contract admin
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    error NoAccess(address target, bytes4 sig, address caller);

    IRoleAccess public roleAccess;
    uint256 public amount;

    constructor() {}

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
