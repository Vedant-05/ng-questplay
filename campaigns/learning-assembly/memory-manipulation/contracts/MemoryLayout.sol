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
        // 1. Allocate memory for the array
        array := mload(0x40)

        // 2. Set the length of the array (first 32 bytes)
        mstore(array, size)
        
        // 3. Set data pointer after the length (next 32 bytes)
        let dataPtr := add(array, 0x20)
        
        // 4. Initialize array elements with the value (1 byte per element)
        for { let i := 0 } lt(i, size) { i := add(i, 1) } {
            mstore8(dataPtr, value)
            dataPtr := add(dataPtr, 1)
        }
        
        // 5. Align memory and update the free memory pointer
        let totalSize := add(0x20, and(add(size, 31), not(31))) // Align to 32-byte boundary
        mstore(0x40, add(array, totalSize))
    }
    }
}
