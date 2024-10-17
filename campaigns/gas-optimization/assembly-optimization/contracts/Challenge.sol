// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract Challenge {

    /**
     * @notice Returns a copy of the given array in a gas efficient way.
     * @dev This contract will be called internally. Uses inline assembly for optimization.
     * @param array The array to copy.
     * @return copy The copied array.
     */
    function copyArray(bytes memory array) 
        internal 
        pure 
        returns (bytes memory copy) 
    {
       
        uint256 len = array.length;

        assembly {

            copy := mload(0x40)

            mstore(copy, len)

            mstore(0x40, add(add(copy, len), 0x20))

            let src := add(array, 0x20)

            let dst := add(copy, 0x20)

            for { let end := add(src, len) } lt(src, end) { src := add(src, 0x20) dst := add(dst, 0x20) } {
                mstore(dst, mload(src))
            }
        }
    }
}