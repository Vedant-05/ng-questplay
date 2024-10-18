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
            let totalSize := add(0x20, mul(div(add(size, 31), 32), 32))
            
            // Update free memory pointer
            mstore(0x40, add(memPtr, totalSize))
            
            // Initialize array elements
            let dataPtr := add(memPtr, 0x20)
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore8(add(dataPtr, i), value)
            }
        }
    }
}