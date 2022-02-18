// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 아래와 같이 다른 솔리디티 파일을 임포트해서 사용할 수 있다.
import "./ZombieFactory.sol";

/*
아래와 같이 인터페이스를 정의하여 우리가 소유하고 있지 않은 블록체인에 대한 콘트랙트를 사용할 수 있다.
이때 함수는 본문에 대한 부분을 제외하고 작성되어야 한다.

이때 유사하지만 다른 개념으로 추상 컨트랙트와 인터페이스가 존재한다.
해당 부분은 솔리디티의 객체 지향 프로그래밍(OOP_Object Oriented Programming)과 연관된 부분이다.

먼저 추상 컨트랙트(abstract contract)의 경우 하나의 함수만이라도 추상 함수(Abstract Function)로 정의되어 있으면 추상 컨트랙트로 간주된다.
이때 추상 컨트랙트를 만드는 방법으로는 크게 abstarct 키워드와 virtual 키워드를 사용하는 방법이 존재한다.
(참고로 virtual 키워드의 경우 0.6.0 버전 이후 등장한 문법이다.)

먼저 abstract 키워드를 사용하는 경우 contract 키워드 대신 사용하여 해당 컨트랙트 내부의 모든 걸 추상화시킨다.
따라서 아래 ChildA 컨트랙트처럼 abstract 키워드를 사용한 추상 컨트랙트 ParentA를 상속 받을 경우 내부 함수인 testA()의 본문을 무조건 상속 받아 구현해야 한다.

abstract contract ParentA {
    function testA() public virtural returns (uint);
}

contract ChildA is ParentA {
    function testA() public override returns (uint) { return 10; }
}

반대로 virtual 키워드를 사용하여 특정 함수만 추상 함수로 만들어서 해당 컨트랙트를 추상 컨트랙트로 만드는 경우 컨트랙트를 상속만 받고 별다른 override를 하지 않아도 괜찮다.
따라서 아래 ChildB 컨트랙처럼 virtual 키워드를 사용하여 tesB() 함수를 추상화한 추상 컨트랙트 ParentB를 상속 받을 경우 해당 함수인 testB()의 본문을 상속 받아 구현하지 않아도 된다.

contract ParentB {
    function testB() public virtual returns (uint);
}

contract ChildB is ParentB {}

결론적으로 abstract 키워드를 사용한 추상 컨트랙트 생성 방식이 개발자에게 내부 함수 구현 등에 대해 더 강제성을 부여한다.
이러한 추상 컨트랙트는 템플릿 메서드 패턴에 어울리는 방법이다.

여기서 템플릿 메서드 패턴(Template Method Pattern)이란 어떤 작업을 처리하는 일부분을 서브 클래스로 캡슐화해서 전체 일을 수행하는 구조는 바꾸지 않으며 특정 단계에서 수행하는 내역을 바꾸는 패턴을 의미한다.
다시 말해 부모 컨트랙트에 동일하게 필요한 함수를 정의한 뒤 이를 종속 받은 자식 컨트랙트가 필요한 방식으로 확장, 변화하여 구현하여 코드 중복을 최소화하는 패턴을 의미한다.

interface 키워드를 사용하여 구현할 경우 본문 내용이 존재하는 함수, 다시 말해 구현이 완료된 함수를 절대 포함할 수 없다.
또한 내부 함수의 경우 필히 external 키워드를 사용해야 한다.

abstract 키워드를 사용할 경우 반대로 구현이 완료된 함수도 포함될 수 있다.
그 예시는 아래 컨트랙트의 testD() 함수와 같다.

abstract contract ParentC {
    function testC() public virtual returns (uint);
    function testD() public pure returns (uint) { return 2; }
}

추가적으로 private 함수는 virtual 함수가 될 수 없다.
또한 인터페이스 외부의 구현되지 않은 함수에는 virtual 키워드를 써야 하며 인터페이스 내부의 함수는 자동으로 virtual 함수로 고려된다.
인터페이스 함수를 상속 받아서 override 할 때 0.8.8 버전 이후부터는 다중 상속을 받는 경우가 아닌 이상 더이상 override 키워드를 사용하지 않아도 된다.

솔리디티에서 다중 상속은 아래와 같이 구현할 수 있다.

constract Child is Mother, Father {}

이때 특이한 점은 파이썬과 달리 우측에서 좌측으로 상속의 순서가 결정되어 Father를 먼저 상속 받게 된다.
따라서 그 순서는 Child -> Father -> Mother 컨트랙트와 같다.

이때 만약 Father 컨트랙트와 Mother 컨트랙트 모두 Grand 컨트랙트를 상속 받는다면 Grand 컨트랙트는 제일 뒤로 순서가 밀리게 된다.
따라서 그 순서는 Child -> Father -> Mother -> Grand 컨트랙트와 같다.
솔리디티는 내부적으로 Father 컨트랙트가 Grand 컨트랙트를 상속 받을 경우 해당 Grand 컨트랙트가 또다른 컨트랙트에 부모가 되지 않는 지 먼저 확인한다.
그리고 만약 다른 컨트랙트에서 - 위 경우에서는 Mother 컨트랙트 - Grand 컨트랙트를 상속 받을 경우 그 순서를 제일 뒤로 미룬다.

솔리디티는 이러한 방식으로 다중 상속이 일으킬 수 있는 다이아몬드 문제를 예방할 수 있고 또한 C3 선형화 알고리즘(linerization Algorithm)을 채택하고 있다.
*/
interface KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
  );
}

/*
솔리디티에서는 아래와 같이 ChildContract is ParentContract 형태로 특정 컨트랙트를 상속 받을 수 있다.
상속 받은 컨트랙트는 부모 컨트랙트에 정의된 public 함수를 사용할 수 있다.
*/
contract ZombieFeeding is ZombieFactory {

    // 아래와 같이 address를 통해 KittyInterface를 사용할 수 있다.
    // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // KittyInterface kittyContract = KittyInterface(ckAddress);

    /*
    솔리디티의 경우 한 번 배포한 이후 배포된 부분을 절대 수정할 수 없다. 보안 및 안정성 관련된 부분을 고려하기 때문이다.
    따라서 한 번 배포되어 정상적으로 컨트랙트가 실행될 경우 이는 어떤 일이 있어도 해당 코드는 오류 없이 정상적으로 실행된다는 걸 보장한다.
    */
    KittyInterface kittyContract;

    modifier ownerOf(uint _zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender);
        _;
    }

    function setKittyContractAddress(address _address) external {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }

    function feeAndMuliply(uint _zombieId, uint _targetDna, string memory _species) internal ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];

        require(_isReady(myZombie));

        _targetDna %= dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;

        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - (newDna % 100) + 99;
        }

        /*
        _createZombie() 함수의 경우 기존에는 private 함수였기 때문에 해당 컨트랙트를 상속 받은 자식 컨트랙트가 함수를 사용할 수 없다.
        따라서 internal 함수로 변경해줘야 한다.

        이전에 설명했던 것처럼 public, private 외에도 interal, external 접근 제어 키워드가 존재하는데 아래와 같은 차이가 있다.
        internal 키워드의 경우 private 함수이지만 상속 받은 자식 컨트랙트는 해당 함수를 사용할 수 있다.
        external 키워드의 경우 public 함수이지만 오로지 콘트랙트 외부에서만 호출될 수 있다.
        */
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public onlyOwner {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feeAndMuliply(_zombieId, kittyDna, "kitty");
    }
}