// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DynamicArray {

    /// @notice Copies `array` into a new memory array 
    /// and pushes `value` into the new array.
    /// @return array_ The new array to return.
    function push(
        uint256[] memory array, 
        uint256 value
    ) public pure returns (uint256[] memory array_) {
        assembly {
            let length := add(mload(array), 1)
            let memptr := mload(0x40)
            array_ := memptr

            // Store new length
            mstore(memptr, length)

            // Update free memory pointer
            mstore(0x40, add(memptr, add(0x20, mul(length, 0x20))))

            // Copy existing array elements
            let srcPtr := add(array, 0x20)
            let destPtr := add(memptr, 0x20)
            for { let i := 0 } lt(i, sub(length, 1)) { i := add(i, 1) } {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 0x20)
                destPtr := add(destPtr, 0x20)
            }

            // Add new element
            mstore(destPtr, value)
        }
    }

    /// @notice Pops the last element from a memory array.
    /// @dev Reverts if array is empty.
    function pop(uint256[] memory array) 
        public 
        pure 
        returns (uint256[] memory array_) 
    {
        assembly {
            let length := mload(array)
            if iszero(length) {
                revert(0, 0)
            }

            // Return the original array with reduced length
            array_ := array
            mstore(array_, sub(length, 1))
        }
    }

    /// @notice Pops the `index`th element from a memory array.
    /// @dev Reverts if index is out of bounds.
    function popAt(uint256[] memory array, uint256 index) 
        public 
        pure 
        returns (uint256[] memory array_) 
    {
        assembly {
            let length := mload(array)
            
            // Check if index is out of bounds
            if or(iszero(lt(index, length)), iszero(length)) {
                revert(0, 0)
            }

            // Return the original array pointer
            array_ := array

            // Reduce length by 1
            mstore(array_, sub(length, 1))

            // Shift elements after index
            let srcPtr := add(add(array, 0x20), mul(add(index, 1), 0x20))
            let destPtr := add(add(array, 0x20), mul(index, 0x20))
            let bytesToMove := mul(sub(sub(length, index), 1), 0x20)
            
            for { let i := 0 } lt(i, bytesToMove) { i := add(i, 0x20) } {
                mstore(add(destPtr, i), mload(add(srcPtr, i)))
            }
        }
    }
}