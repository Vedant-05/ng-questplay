// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Scrambled {

    /// @notice Recover an address that has been scrambled...
    function recoverAddress(bytes32 value)
        public
        pure
        returns (address rvalue)
    {
        assembly {
        // desired blue 8 bytes green 6 bytes purple 6 bytes
        //  8 B, 6 G, 6 P
        // given 1byte trash 6 byte purple 8 byte trash 6 byte green 2 bytes trash 8 bytes blue part 1 byte trash
        // 1T,6P,8T,6G,2T,8B,1T
         let desiredBluePart := shl(mul(23,8),value)
         desiredBluePart := shr(mul(24,8),desiredBluePart)

         let desiredgreenPart := shl(mul(15,8),value)
         desiredgreenPart := shr(mul(26,8),desiredgreenPart)

         let desiredPurplePart := shl(mul(1,8),value)
         desiredPurplePart := shr(mul(26,8),desiredPurplePart)

         rvalue := shl(mul(6,8),desiredBluePart)

         rvalue := or(rvalue,desiredgreenPart)

         rvalue := shl(mul(6,8),rvalue)

         rvalue := or(rvalue,desiredPurplePart)
            
        }
    }
}
