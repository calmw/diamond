// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import "./diamond/libraries/LibDiamond.sol";

contract RoleAccess is AccessControl {
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE"); // impl contract
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    event GrantAccess(
        address target,
        bytes4 sig,
        bytes32 role
    );
    event SuperCheck(
        bytes4 sig,
        bool status
    );

    enum AccessType{
        RBAC, // RBAC
        ACP // access by parameter
    }

    struct Access {
        bytes32 role_;
        AccessType type_;
    }

    // contract address=>(selector=>role)
    mapping(address => mapping(bytes4 => Access)) public _access;

    constructor(){
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    function checkAccess(
        address target,
        address caller,
        bytes4 sig
    ) public view returns (bool) {
        bytes32 role = _access[target][sig].role_;

        // no permission required
        if (role == bytes32(0)) {
            return true;
        }

        Access memory access = _access[target][sig];
        if (access.type_ == AccessType.RBAC) {
            return checkRBAC(caller, role);
        } else if (access.type_ == AccessType.ACP) {
            if (sig == 0x791fc071) {
                // msg.data
            } else if (sig == 0x791fc070) {
                // msg.data
            }
        }
        return false;
    }

    function grantAccess(
        address target,
        bytes4 sig,
        bytes32 role,
        AccessType accessType
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _access[target][sig] = Access(role, accessType);

        emit GrantAccess(
            target,
            sig,
            role
        );
    }

    function checkRBAC(
        address caller,
        bytes32 role
    ) public view returns (bool) {
        // contract call between impls
        if (role == CONTRACT_ROLE) {
            address[] memory facets = getFacets();
            bool exist;
            for (uint256 i; i < facets.length; i++) {
                if (facets[i] == msg.sender) {
                    exist = true;
                    break;
                }
            }
            return exist;
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

    function getFacets() public view returns (address[] memory) {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }

        return ds.facetAddresses;
    }
}
