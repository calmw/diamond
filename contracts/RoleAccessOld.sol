// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract RoleAccessOld is AccessControl {
    bytes32 public constant GENERAL_ADMIN_ROLE =
        keccak256("GENERAL_ADMIN_ROLE"); // contract admin
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    error NoAccess(address caller);

    // contract address=>role
    mapping(address => bytes32) public _access;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setContractRole(
        address target,
        bytes32 role
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _access[target] = role;
    }

    //    function setContractRole(
    //        address target
    //    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
    //        _access[target] = bytes32(abi.encode(target)); // bytes20 to bytes32
    //    }

    function checkAccess(
        address target,
        address caller
    ) public view returns (bool) {
        bytes32 role = _access[target];

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
