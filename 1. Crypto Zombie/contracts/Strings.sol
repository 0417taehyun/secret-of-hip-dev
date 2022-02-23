// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";


    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
    }
}