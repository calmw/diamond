// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
*
* Implementation of a diamond.
/******************************************************************************/

import {LibDiamond} from "./libraries/LibDiamond.sol";
import {IDiamondCut} from "./interfaces/IDiamondCut.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract DiamondWithRoleAccess is AccessControl {
    bytes32 public constant GENERAL_ADMIN_ROLE =
        keccak256("GENERAL_ADMIN_ROLE"); // contract admin
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE"); // manager
    bytes32 public constant ADMINISTRATOR = keccak256("ADMINISTRATOR"); // administrator

    error NoAccess(address caller);

    // contract address=>(selector=>role)
    mapping(address => mapping(bytes4 => bytes32)) public _access;

    constructor(address _diamondCutFacet) payable {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        LibDiamond.setContractOwner(msg.sender);

        // Add the diamondCut external function from the diamondCutFacet
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: _diamondCutFacet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        LibDiamond.diamondCut(cut, address(0), "");
    }

    function grantAccess(
        address target,
        bytes4 sig,
        bytes32 role
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _access[target][sig] = role;
    }

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

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        // get diamond storage
        assembly {
            ds.slot := position
        }
        // get facet from function selector
        address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
        require(facet != address(0), "Diamond: Function does not exist");

        require(checkRBAC(address(this), msg.sig, msg.sender), "no access");

        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)

            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}
