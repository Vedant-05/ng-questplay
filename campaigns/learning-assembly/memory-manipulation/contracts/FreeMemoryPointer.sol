// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FreeMemoryPointer {

    /// @notice Returns the value of the free memory pointer.
    function getFreeMemoryPointer() internal pure returns (uint256 memoryAddress) {
        assembly {
              memoryAddress := mload(0x40)
        }
    }

    /// @notice Returns the highest memory address accessed so far.
    function getMaxAccessedMemory() internal pure returns (uint256 memoryAddress) {
        assembly {

            memoryAddress := msize()

        }
    }

    /// @notice Allocates `size` bytes in memory.
    /// @return memoryAddress Address of start of allocated memory.
    function allocateMemory(uint256 size) internal pure returns (uint256 memoryAddress) {
        assembly {

           // Get the current free memory pointer
        memoryAddress := mload(0x40)
        
        // Advance the free memory pointer by `size` bytes
        mstore(0x40, add(memoryAddress, size))

        }
    }

    /// @notice Frees the highest `size` bytes from memory.
    /// @dev Should revert if reserved space will be deallocated.
    function freeMemory(uint256 size) internal pure {
        assembly {
            
             // Get the current free memory pointer
        let freeMemoryPointer := mload(0x40)
        
        // Calculate the new free memory pointer
        let newFreeMemoryPointer := sub(freeMemoryPointer, size)
        
        // Check if we're trying to deallocate reserved space
        if lt(newFreeMemoryPointer, 0x80) {
            revert(0, 0)
        }
        
        // Update the free memory pointer
        mstore(0x40, newFreeMemoryPointer)
        }
    }
}