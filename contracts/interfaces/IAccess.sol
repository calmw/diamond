// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IAccess {
    function checkAccess(
        address target,
        address caller,
        bytes4 sig
    ) external view returns (bool);
}
