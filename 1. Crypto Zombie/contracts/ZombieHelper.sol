// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    
    // modifier에도 매개변수를 전달할 수 있다.
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // calldata는 memory와 유사하지만 external 함수에서만 가능하다.
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender);
        zombies[_zombieId].dna = _newDna;
    }

    /*
    함수 제어자 중 view를 사용한 함수의 경우 별도의 Gas 비용을 지불하지 않는다.
    왜냐하면 web3.js에게 별도의 트랜잭션을 생성하지 않고 단순히 로컬 이더리움 노드를 통해 함수를 호출하기만 할 뿐이기 때문이다.
    쉽게 view 함수는 읽기 전용 함수이기 때문에 블록체인 내에서 아무 것도 변경하지 않아 Gas 비용을 지불하지 않는다고 생각하면 편하다.

    이때 유의할 점은 view 함수가 외부에서 호출 될 때만 Gas 비용을 제출하지 않는다는 점이다.
    만약 동일한 콘트랙트 내부에서 다른 함수가 view 함수를 호출할 경우 이더리움 상에서 다른 함수가 트랜잭션을 생성하기 때문에 view 함수 또한 Gas 비용을 지불해야 한다.
    */
    function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
        
        /*
        솔리디티에서는 외부에서 호출한 view 함수가 별도의 Gas 비용을 지불하지 않기 때문에 storage 데이터로 배열을 만들어 전역에서 관리하는 것보다
        memory 데이터로 배열을 만들어 함수 내부에서만 해당 배열이 존재했다가 함수의 호출이 끝나면 사라지게 하는 것이 훨씬 비용 효율적이다.

        배열의 종류에는 동적 배열과 정적 배열이 존재하는데 앞서 Zombie[] 배열을 선언한 방식이 동적 배열을 만드는 방법이고
        아래와 같이 new 키워드를 사용하여 뒤에 크기를 지정하여 선언하는 방식이 정적 배열이다.
        */
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        
        uint counter = 0;
        for (uint index; index < zombies.length; index++) {
            if (zombieToOwner[index] == _owner) {
                result[counter] = index;
                counter++;
            }
        }
        return result;
    }
}