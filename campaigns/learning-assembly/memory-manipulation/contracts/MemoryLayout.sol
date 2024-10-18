// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MemoryLayout {

    /// @notice Create an uint256 memory array.
    /// @param size The size of the array.
    /// @param value The initial value of each element of the array.
    function createUintArray(
        uint256 size, 
        uint256 value
    ) public pure returns (uint256[] memory array) {
        assembly {
            // Allocate memory for the array
            // Array length (32 bytes) + size * 32 bytes (each uint256 is 32 bytes)
            let memPtr := mload(0x40)
            array := memPtr
            
            // Store the length of the array
            mstore(memPtr, size)
            
            // Update free memory pointer
            mstore(0x40, add(memPtr, add(0x20, mul(size, 0x20))))
            
            // Initialize array elements
            let dataPtr := add(memPtr, 0x20)
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore(dataPtr, value)
                dataPtr := add(dataPtr, 0x20)
            }
        }
    }

    /// @notice Create a bytes memory array.
    /// @param size The size of the array.
    /// @param value The initial value of each element of the array.
    function createBytesArray(
        uint256 size, 
        bytes1 value
    ) public pure returns (bytes memory array) {
        assembly {
            // Allocate memory for the array
            let memPtr := mload(0x40)
            array := memPtr
            
            // Store the length of the array (in bytes)
            mstore(memPtr, size)
            
            // Calculate total size (32 bytes for length + actual data size, rounded up to nearest 32 bytes)
            let totalSize := and(add(add(size, 0x20), 0x1f), not(0x1f))
            
            // Update free memory pointer
            mstore(0x40, add(memPtr, totalSize))
            
            // Initialize array elements (left-aligned)
            let dataPtr := add(memPtr, 0x20)
            let word := 0
            let bytesLeft := size
            for { let i := 0 } lt(i, totalSize) { i := add(i, 0x20) } {
                if iszero(bytesLeft) { break }
                word := 0
                for { let j := 0 } and(lt(j, 0x20), gt(bytesLeft, 0)) { j := add(j, 1) } {
                    word := or(shl(248, value), shr(8, word))
                    bytesLeft := sub(bytesLeft, 1)
                }
                mstore(add(dataPtr, i), word)
            }
        }
    }
}