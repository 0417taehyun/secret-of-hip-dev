// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper {

    /*
    아래와 같은 방법은 실제 배포 이후 보안에 문제가 발생할 수 있다.
    한 가지 해결책으로는 oracle을 사용하는 것이다.
    */
    uint randNonce = 0;
    function randMod(uint _modulus) internal returns (uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
}