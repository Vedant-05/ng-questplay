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
           // Allocate memory
            array := mload(0x40)
            
            // Store length
            mstore(array, size)
            
            // Calculate words to allocate (round up)
            let words := div(add(size, 31), 32)
            
            // Initialize array elements and pad with zeros
            let dataPtr := add(array, 0x20)
            for { let i := 0 } lt(i, words) { i := add(i, 1) } {
                mstore(add(dataPtr, mul(i, 0x20)), 0)
            }
            
            // Fill with actual data
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore8(add(dataPtr, i), value)
            }
            
            // Update free memory pointer
            mstore(0x40, add(array, add(0x20, mul(words, 0x20))))
        }
    }
}
