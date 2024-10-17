// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SafeMath {

    /// @notice Returns lhs + rhs.
    /// @dev Reverts on overflow / underflow.
    function add(
        int256 lhs, 
        int256 rhs
    ) public pure returns (int256 result) {
        // Convert this to assembly
        assembly{
        result := add(lhs, rhs)
            // Check overflow: (result > 0 && lhs < 0 && rhs < 0) || (result < 0 && lhs > 0 && rhs > 0)
            if or(
                and(and(sgt(result, 0), slt(lhs, 0)), slt(rhs, 0)),
                and(and(slt(result, 0), sgt(lhs, 0)), sgt(rhs, 0))
            ) {
                revert(0, 0)
            }
            }
    }

    /// @notice Returns lhs - rhs.
    /// @dev Reverts on overflow / underflow.
    function sub(int256 lhs, int256 rhs) public pure returns (int256 result) {
        // Convert this to assembly
        assembly {
             result := sub(lhs, rhs)
             // Check overflow: (result > 0 && lhs < 0 && rhs > 0) || (result < 0 && lhs > 0 && rhs < 0)
            if or(
                and(and(sgt(result, 0), slt(lhs, 0)), sgt(rhs, 0)),
                and(and(slt(result, 0), sgt(lhs, 0)), slt(rhs, 0))
            ) {
                revert(0, 0)
            }
        }
    }

    /// @notice Returns lhs * rhs.
    /// @dev Reverts on overflow / underflow.
    function mul(int256 lhs, int256 rhs) public pure returns (int256 result) {
        // Convert this to assembly
         assembly {
            // Perform the multiplication
            result := mul(lhs, rhs)

            // Check for overflow
            // Case 1: If either input is 0, the result must be 0
            // Case 2: If the result divided by lhs is not equal to rhs, there was an overflow
            // Case 3: Special checks for INT256_MIN and INT256_MAX
            switch or(or(eq(lhs, 0), eq(rhs, 0)), eq(lhs, 1))
            case 0 {
                if or(
                    iszero(eq(sdiv(result, lhs), rhs)),
                    or(
                        and(eq(lhs, sub(0, 1)), eq(rhs, 0x8000000000000000000000000000000000000000000000000000000000000000)),
                        and(eq(rhs, sub(0, 1)), eq(lhs, 0x8000000000000000000000000000000000000000000000000000000000000000))
                    )
                ) {
                    revert(0, 0)
                }
            }

            // Additional check for INT256_MIN * -1 and -1 * INT256_MIN
            if or(
                and(eq(lhs, 0x8000000000000000000000000000000000000000000000000000000000000000), eq(rhs, sub(0, 1))),
                and(eq(rhs, 0x8000000000000000000000000000000000000000000000000000000000000000), eq(lhs, sub(0, 1)))
            ) {
                revert(0, 0)
            }
        }
    }

    /// @notice Returns lhs / rhs.
    /// @dev Reverts on overflow / underflow.
    function div(int256 lhs, int256 rhs) public pure returns (int256 result) {
        // Convert this to assembly
        assembly {
            // Check division by zero
            if eq(rhs, 0) {
                revert(0, 0)
            }
            // Check for overflow: INT256_MIN / -1
            if and(
                eq(lhs, 0x8000000000000000000000000000000000000000000000000000000000000000),
                eq(rhs, sub(0, 1))
            ) {
                revert(0, 0)
            }
            result := sdiv(lhs, rhs)
        }
    }
}
