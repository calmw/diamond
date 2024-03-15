// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract RoleActionAccess is AccessControl {
    bytes32 public constant GENERAL_ADMIN_ROLE =
        keccak256("GENERAL_ADMIN_ROLE"); // contract admin
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    error NoAccess(address caller);

    // contract address=>(selector=>role)
    mapping(address => mapping(bytes4 => bytes32)) public _access;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setActionRole(
        address target,
        bytes4 sig,
        bytes32 role
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _access[target][sig] = role;
    }

    //    function setActionRole(
    //        address target,
    //        bytes4 sig
    //    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
    //        _access[target][sig] = bytes32(abi.encode(target)); // bytes20 to bytes32
    //    }



    // Role-Based Access Control
    function checkRBAC(
        address target,
        bytes4 sig,
        address caller
    ) public view returns (bool) {
        bytes32 role = _access[target][sig];

        // no permission required
        if (role == bytes32(0)) {
            return true;
        }

        // skip admin
        if (
            hasRole(ADMINISTRATOR, caller) ||
            hasRole(DEFAULT_ADMIN_ROLE, caller)
        ) {
            return true;
        }

        return hasRole(role, caller);
    }
}
