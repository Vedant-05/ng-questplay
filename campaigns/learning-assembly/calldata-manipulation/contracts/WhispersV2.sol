// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract WhispersV2 {
    /// @notice Converts a compressed uint256 array into standard uint256[].
    function compressedWhisper() public pure returns (uint256[] memory) {
        assembly {
            // Get the size of calldata
            let dataSize := sub(calldatasize(), 4)
            
            // First pass: count the number of elements
            let offset := 4  // Start after function selector
            let arrayLength := 0
            for {} lt(offset, calldatasize()) {} {
                let length := byte(0, calldataload(offset))
                offset := add(offset, add(length, 1))
                arrayLength := add(arrayLength, 1)
            }

            // Allocate memory for the result array
            let memPtr := mload(0x40)
            // Store the array length
            mstore(memPtr, arrayLength)
            // Calculate the total size: 32 bytes for length + 32 bytes per element
            let totalSize := add(32, mul(arrayLength, 32))
            // Update the free memory pointer
            mstore(0x40, add(memPtr, totalSize))
            
            // Second pass: decode and store values
            offset := 4
            let dataPtr := add(memPtr, 32)
            for { let i := 0 } lt(i, arrayLength) { i := add(i, 1) } {
                let length := byte(0, calldataload(offset))
                offset := add(offset, 1)
                
                let value := 0
                for { let j := 0 } lt(j, length) { j := add(j, 1) } {
                    let byteValue := byte(j, calldataload(offset))
                    value := or(value, shl(mul(sub(length, add(j, 1)), 8), byteValue))
                }
                offset := add(offset, length)
                
                mstore(dataPtr, value)
                dataPtr := add(dataPtr, 32)
            }
            
            // Return the array
            return(memPtr, totalSize)
        }
    }
}