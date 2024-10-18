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
    ) public pure returns (bytes memory array) {
     assembly {
      // Calculate total size (including padding)
            let totalSize := add(0x20, size) // 0x20 (32 bytes) for length + size
            let remainder := mod(size, 0x20)
            if gt(remainder, 0) {
                totalSize := add(totalSize, sub(0x20, remainder))
            }

            // Allocate memory for the array
            array := mload(0x40)

            // Set the length of the array (first 32 bytes)
            mstore(array, size)
            
            // Initialize array elements with the value (1 byte per element)
            let dataPtr := add(array, 0x20)
            let end := add(dataPtr, size)
            for {} lt(dataPtr, end) { dataPtr := add(dataPtr, 1) } {
                mstore8(dataPtr, value)
            }
            
            // Update the free memory pointer
            mstore(0x40, add(array, totalSize))
    }
    }
}
