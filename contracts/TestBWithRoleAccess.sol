// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IRoleAccess} from "./interfaces/IRoleAccess.sol";

contract TestBWithRoleAccess is IRoleAccess {
    bytes32 public constant GENERAL_ADMIN_ROLE =
        keccak256("GENERAL_ADMIN_ROLE"); // contract admin
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    error NoAccess(address target, bytes4 sig, address caller);

    IRoleAccess private roleAccess;
    uint256 public amount;

    constructor(address roleAccess_) {
        roleAccess = IRoleAccess(roleAccess_);
    }

    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    function _checkRole(bytes32 role) internal view {
        if (!roleAccess.checkRBAC(address(this), msg.sig, msg.sender)) {
            revert NoAccess(address(this), msg.sig, msg.sender);
        }
    }

    function addInt(
        uint256 a,
        uint256 b
    ) public pure onlyRole(GENERAL_ADMIN_ROLE) returns (uint256) {
        return a + b;
    }

    function addAmount() public {
        amount += 1;
    }

    function getAmount() public view returns (uint256) {
        return amount;
    }
}
