// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract RoleAccess is AccessControl {
    bytes32 public constant GENERAL_ADMIN_ROLE =
        keccak256("GENERAL_ADMIN_ROLE"); // contract admin
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    // for test，you can grant role by log
    event AccessLog(address target, bytes32 role, bytes4 sig, address caller);

    error NoAccess(address caller);

    // contract address=>(role=>(selector=>(caller=>has access))
    mapping(address => mapping(bytes32 => mapping(bytes4 => mapping(address => bool))))
        private _access;
    // caller=>role array
    mapping(address => bytes32[]) private _roles;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function grantAccess(
        address target,
        bytes32 role,
        bytes4 sig,
        address caller
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _access[target][role][sig][caller] = true;
    }

    function grantRole(
        bytes32 role,
        address account
    ) public virtual override onlyRole(DEFAULT_ADMIN_ROLE) {
        _addRole(role, account);
        _grantRole(role, account);
    }

    function revokeRole(
        bytes32 role,
        address account
    ) public virtual override onlyRole(DEFAULT_ADMIN_ROLE) {
        _removeRole(role, account);
        _grantRole(role, account);
    }

    function renounceRole(
        bytes32 role,
        address account
    ) public virtual override {
        require(
            account == _msgSender(),
            "AccessControl: can only renounce roles for self"
        );
        _removeRole(role, account);
        _revokeRole(role, account);
    }

    function _addRole(bytes32 role, address caller) private {
        bool exist;
        for (uint256 i = 0; i < _roles[caller].length; i++) {
            if (role == _roles[caller][i]) {
                exist = true;
                break;
            }
        }
        if (!exist) {
            _roles[caller].push(role);
        }
    }

    function _removeRole(bytes32 role, address caller) private {
        uint256 len = _roles[caller].length;
        for (uint256 i = 0; i < len; i++) {
            if (role == _roles[caller][i]) {
                _roles[caller][i] = _roles[caller][len - 1];
                _roles[caller].pop();
            }
        }
    }

    function checkRBAC(
        address target,
        bytes4 sig,
        address caller
    ) private returns (bool) {
        if (
            hasRole(ADMINISTRATOR, caller) ||
            hasRole(DEFAULT_ADMIN_ROLE, caller)
        ) {
            return true;
        }

        bytes32 role;
        for (uint256 i = 0; i < _roles[caller].length; i++) {
            role = _roles[caller][i];
            if (_access[target][role][sig][caller]) {
                return true;
            }
        }

        /// for test
        emit AccessLog(target, role, sig, caller);
        ///

        return false;
    }
}
