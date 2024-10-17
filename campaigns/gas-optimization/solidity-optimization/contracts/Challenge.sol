// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {
    uint256 private immutable _SKIP;

    constructor(uint256 skip) {
        _SKIP = skip;
    }

    /** 
     * @notice Returns the sum of the elements of the given array, skipping any SKIP value.
     * @dev Reverts on overflow.
     * @param array The array to sum.
     * @return sum The sum of all the elements of the array excluding SKIP.
     */
    function sumAllExceptSkip(
        uint256[] calldata array
    ) public view returns (uint256 sum) {
        uint256 skip = _SKIP;
        // uint256 length = array.length;  this will use more gas then accesing directly the array length storing this in memory will cost more than getting length from calldata
        //    from  calldata to get array length 2 gas from memory it is 3 gas
        // to access value of uint256 from memory it is 3 gas 
        for (uint256 i; i < array.length;) {
            uint256 element = array[i];   // once value reference it stores in the stack usage and gas reduces for further acces to this value
            if (element != skip) {
                sum += element;
            }
            unchecked { ++i; }
        }
    }
}