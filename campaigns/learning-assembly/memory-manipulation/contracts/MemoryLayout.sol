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
     
// Allocate memory and log
    array := mload(0x40)
    mstore(0x40, add(array, 0x60)) // Log after allocating

    // Check if memory properly allocated
       if iszero(array) { revert(0, 0) }
        // Set data pointer after the length
        let dataPtr := add(array, 0x20)
        
        // Initialize array elements
        for { let i := 0 } lt(i, size) { i := add(i, 1) } {
            mstore8(dataPtr, value)
            dataPtr := add(dataPtr, 1)
        }

       let totalSize := add(0x20, mul(0x20, div(add(size, 31), 32)))
       mstore(0x40, add(array, totalSize))

    
        }
    }
}
