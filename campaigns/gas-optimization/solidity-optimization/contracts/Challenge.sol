// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {

    uint256 immutable _SKIP;

    constructor(uint256 skip) {
        _SKIP = skip;
    }

    /** 
     * @notice Returns the sum of the elements of the given array, skipping any SKIP value.
     * @param array The array to sum.
     * @return sum The sum of all the elements of the array excluding SKIP.
     */

    function sumAllExceptSkip(
        uint256[] calldata array
    ) public view returns (uint256) {
        uint256 sum;
        uint256 skip = _SKIP;
        uint256 len = array.length;

        assembly {
            let i := 0
            let dataStart := array.offset
            for {} lt(i, len) {} {
                let element := calldataload(add(dataStart, mul(i, 0x20)))
                let shouldAdd := iszero(eq(element, skip))
                
              
                if and(shouldAdd, gt(element, sub(not(0), sum))) {
                   
                    mstore(0x00, 0x4e487b7100000000000000000000000000000000000000000000000000000000)
                    mstore(0x04, 0x11)
                    revert(0, 0x24)
                }
                
                sum := add(sum, mul(element, shouldAdd))
                i := add(i, 1)
            }
        }

        return sum;
    
    }

}
