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
            // 1. Read start of free memory
            array := mload(0x40)
            // 2. Record the length of the array
            mstore(array, size)
            // 3. Initialize array elements
            let dataPtr := add(array, 0x20)
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore(dataPtr, value)
                dataPtr := add(dataPtr, 0x20)
            }
            // 4. Mark the array memory area as allocated
            mstore(0x40, dataPtr)
        }
    }

    /// @notice Create a bytes memory array.
    /// @param size The size of the array.
    /// @param value The initial value of each element of the array.
    function createBytesArray(
        uint256 size, 
        bytes1 value
    ) public pure returns (bytes memory) {
         assembly {
            // Allocate memory for the bytes array
            let ptr := mload(0x40)
            
            // Store the length of the bytes array
            mstore(ptr, size)
            
            // Calculate the total size including padding
            let totalSize := add(add(size, 0x20), mod(sub(32, mod(size, 32)), 32))
            
            // Update the free memory pointer
            mstore(0x40, add(ptr, totalSize))
            
            // Fill the array with the value
            let dataPtr := add(ptr, 0x20)
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore8(add(dataPtr, i), value)
            }
            
            // Return the pointer to the bytes array
            return(ptr, totalSize)
        }
    }
}