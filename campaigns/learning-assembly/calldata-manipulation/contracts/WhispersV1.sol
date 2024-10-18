// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract WhispersV1 {

    /// @notice Read and return the uint256 appended behind the expected calldata.
    function whisperUint256() external pure returns (uint256 value) {
        assembly {
            // Load the uint256 value from the end of the calldata
            value := calldataload(0x04)
        }
    }

    /// @notice Read and return the string appended behind the expected calldata.
    /// @dev The string is abi-encoded.
    function whisperString() external pure returns (string memory str) {
        assembly {
           // Allocate some free memory
            str := mload(0x40)
            // 4 function selecor 32 for string pointer offset
            let dataLength := calldataload(0x24)

            // Calculate length of data + length header
            let totalLength := add(dataLength, 0x20)

            // Copy length and string data into memory
              calldatacopy(str, 0x24, totalLength)

            // Update free memory pointer
                let allocated := add(str, totalLength)
               mstore(0x40, allocated)


        }
    }

}