// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Masks {

    /// @notice Set all the bits set in mask to 1 in x.
    function setMask(uint256 x, uint256 mask)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            x := or(x,mask)
            rvalue := x
        }
    }

    /// @notice Set all the bits set in mask to 0 in x.
    function clearMask(uint256 x, uint256 mask)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            mask := not(mask)
            x := and(x,mask)
            rvalue := x
            
        }
    }

    /// @notice Get 8 bytes from `x` starting from byte `at` (from the right).
    /// @param x value to extract 8 bytes from.
    /// @param at little endian index.
    function get8BytesAt(uint256 x, uint256 at)
        public
        pure
        returns (uint64 rvalue)
    {
        assembly {
          // Shift x right by (at * 8) bits
        // This aligns the desired 8-byte chunk to the least significant bytes
        let shifted := shr(mul(at, 8), x)
        
        // Mask out all but the least significant 8 bytes (64 bits)
        // 0xffffffffffffffff is a mask with 64 bits set to 1
        
        rvalue := and(shifted, 0xffffffffffffffff)

            
        }
    }
}
