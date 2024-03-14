// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IRoleAccess {
    function checkRBAC(
        address target,
        bytes4 sig,
        address caller
    ) external view returns (bool);
}
