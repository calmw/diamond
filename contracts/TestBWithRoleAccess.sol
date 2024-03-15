// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IRoleAccess} from "./interfaces/IRoleAccess.sol";

contract TestBWithRoleAccess {
    // for test，you can grant access by log
    event AccessLog(address target, bytes4 sig, address caller);

    bytes32 public constant GENERAL_ADMIN_ROLE =
        keccak256("GENERAL_ADMIN_ROLE"); // contract admin
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    error NoAccess(address target, bytes4 sig, address caller);

    IRoleAccess public roleAccess;
    uint256 public amount;

    constructor(address roleAccess_) {
        roleAccess = IRoleAccess(roleAccess_);
    }

    modifier checkAccess() {
        _checkAccess();
        _;
    }

    function _checkAccess() internal view {
        if (!roleAccess.checkRBAC(address(this), msg.sig, msg.sender)) {
            revert NoAccess(address(this), msg.sig, msg.sender);
        }
    }

    function TestBSetRoleAccess(address roleAccess_) public {
        roleAccess = IRoleAccess(roleAccess_);
    }

    function addInt(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function addAmount() public checkAccess {
        amount += 1;
        // address(this) diamond address
        emit AccessLog(address(this), msg.sig, msg.sender);
    }

    function getAmount() public view returns (uint256) {
        return amount;
    }
}
