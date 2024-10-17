// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Arithmetic {

    /// @dev Returns lhs + rhs.
    /// @dev You do not need to care about overflow.
    function addition(
        int256 lhs, 
        int256 rhs
    ) external pure returns (int256 result) {
        assembly {
            result := add(lhs, rhs)
        }
    }

    /// @notice Returns lhs * rhs.
    /// @dev You do not need to care about overflow.
    function multiplication(
        int256 lhs, 
        int256 rhs
    ) external pure returns (int256 result) {
        assembly {
           result := mul(lhs , rhs)
        }
    }

    /// @notice Returns lhs % rhs.
    function modulo(
        uint256 lhs, 
        uint256 rhs
    ) external pure returns (uint256 result) {
        assembly {
             result := mod(lhs,rhs)
        }
    }

    /// @notice Returns lhs ^ rhs.
    function power(
        uint256 lhs, 
        uint256 rhs
    ) external pure returns (uint256 result) {
        assembly {
              result := 1
              for { let i := 0 } lt(i, rhs) { i := add(i, 1) }
              {
                   result := mul(result, lhs)
              }
        }
    }

    /// @notice Returns the signed division lhs / rhs
    function signedDivision(
        int256 lhs, 
        int256 rhs
    ) external pure returns (int256 result) {
        assembly {
            result := sdiv(lhs, rhs)
        }
    }

}
