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
        for (uint i = 0; i < size; i++) {
            array[i] = value;
        }
        return array;
    //  assembly {
    //     // 1. Allocate memory for the array
    //         array := mload(0x40)
            
    //         // 2. Store the length of the array
    //         mstore(array, size)
            
    //         // 3. Calculate the number of words needed (rounded up)
    //         let words := div(add(size, 31), 32)
            
    //         // 4. Calculate total size in memory (1 word for length + data words)
    //         let totalSize := mul(add(words, 1), 32)
            
    //         // 5. Initialize array elements
    //         let dataPtr := add(array, 32)
    //         for { let i := 0 } lt(i, size) { i := add(i, 1) } {
    //             mstore8(add(dataPtr, i), value)
    //         }
            
    //         // 6. Clear any remaining bytes in the last word
    //         let lastWordPtr := add(dataPtr, size)
    //         let remainingBytes := sub(totalSize, add(size, 32))
    //         if gt(remainingBytes, 0) {
    //             mstore(lastWordPtr, 0)
    //         }

    //     //    totalSize := and(add(add(size, 0x20), 0x1f), not(0x1f))
            
    //         // 7. Update the free memory pointer
    //         mstore(0x40, add(array, totalSize))
    // }
    }
}
