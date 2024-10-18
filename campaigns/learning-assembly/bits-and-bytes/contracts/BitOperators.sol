// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitOperators {

    /// @notice Returns x << shift.
    function shiftLeft(uint256 x, uint256 shift)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
             rvalue := shl(shift,x)
        }
    }

    /// @notice Sets the bit at `index` in `x` to `1`.
    /// @return rvalue value with the set bit
    function setBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            x := or(x,shl(index,1))
            rvalue := x
        }
    }

    /// @notice Clears the bit at `index` in `x` to `0`.
    /// @return rvalue value with the cleared bit
    function clearBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
         x := and(x,not(shl(index,1)))
         rvalue := x   
        }
    }

    /// @notice Flips the bit at `index` in `x`.
    /// @return rvalue value with the flipped bit
    function flipBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            let newBitX := and(x,shl(index,1))
            
            switch iszero(and(newBitX,x))

             case 0 { 
                  x := not(or(not(x),shl(index,1)))
             }
             case 1 {
                  x := or(x,shl(index,1))
             }

             rvalue := x

            


            
        }
    }

    /// @notice Gets the bit at `index` in `x`.
    /// @return rvalue 1 if queried bit is `1`, 0 otherwise.
    function getBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {

            let newBitX := and(x,shl(index,1))
            
            switch iszero(and(newBitX,x))

             case 0 { 
                 rvalue := 1
             }
             case 1 {
                 rvalue := 0
             }
            
        }
    }
}
