// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract For {
    
    /// @notice Sum the elements in [`beg`, `end`) and return the result.
    /// Skips elements divisible by 5. 
    /// Exits the summation loop when it encounters a factor of `end`.
    /// @dev You can ignore overflow / underflow bugs.
    function sumElements(uint256 beg, uint256 end)
        public
        pure
        returns (uint256 sum)
    {
        assembly {

           

            for  {let i:= beg} lt(i,end) {i := add(i,1)}  {
                 
                 if iszero(mod(i,5)) {
                     continue
                 }

                 if iszero(mod(end,i)) {
                    break
                 }

                 sum := add(sum, i)
                 
            }


        }
    }
}
