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
         bytes memory array = new bytes(size);
        
        assembly {
            // Get the pointer to the start of the array data
            let dataPtr := add(array, 0x20)
            
            // Fill the array with the value
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore8(add(dataPtr, i), value)
            }
            
            // Ensure proper memory alignment
            let endPtr := add(dataPtr, size)
            let remainder := mod(size, 32)
            if gt(remainder, 0) {
                let padding := sub(32, remainder)
                mstore(endPtr, 0)
                endPtr := add(endPtr, padding)
            }
            
            // Update free memory pointer
            mstore(0x40, endPtr)
        }
        
        return array;
    }
}