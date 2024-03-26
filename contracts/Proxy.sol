// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/******************************************************************************\
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
* Implementation of a diamond.
/******************************************************************************/

import {LibDiamond} from "./diamond/libraries/LibDiamond.sol";
import {IDiamondCut} from "./diamond/interfaces/IDiamondCut.sol";
import "./interface/IAccess.sol";

contract Proxy {

    error NoAccess(string msg, address caller, address target, bytes4 sig);

    constructor(address _diamondCutFacet) payable {

        LibDiamond.setContractOwner(msg.sender);

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

    // get all impls
    function getFacets() public view returns (address[] memory){
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }

        return ds.facetAddresses;
    }

    fallback() external payable {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }

        address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
        require(facet != address(0), "Diamond: Function does not exist");

        address roleAccess = ds.selectorToFacetAndPosition[0x6396eb8d].facetAddress;
        if (!IAccess(roleAccess).checkAccess(facet, msg.sender, msg.sig)) {
            revert NoAccess("no access", msg.sender, facet, msg.sig);
        }

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return (0, returndatasize())
            }
        }
    }

    receive() external payable {}
}
