/*
모든 솔리디티 소스 코드는 Version Pragma로 시작해야 한다.
이를 통해 솔리디티 버전을 선언하여 새로운 컴파일러 버전이 나와도 기존 코드가 깨지지 않게 한다.

또한 SPDX-License-Identifier를 첫 줄에 작성하여 컨트랙트가 라이선스를 함께 빌드할 수 있게 알려줘야 한다.
굳이 작성하지 않아도 되는, 오류가 아닌 주의사항이지만 0.6.8 버전 이후 생긴 방식이기 때문에 작성하는 걸 추천한다.
*/
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9;

/*
솔리디티 코드는 컨트랙트 안에 싸여 있다.
컨트랙트는 이더리움 애플리케이션의 기본적인 구성 요소로 모든 변수와 함수는 어느 한 컨트랙트에 속해야 한다.
*/
contract ZombieFactory {
    /*
    상태 변수는 컨트랙트 저장소에 영구적으로 저장된다. 다시 말해 이더리움 블록체인에 기록되는 것이다.
    이것은 데이터베이스에 데이터가 저장되는 것과 동일하다.
    */

    /*
    uint는 부호 없는 정수를 의미한다. 부호 있는 정수의 경우 int 키워드를 사용한다.
    이외에도 아래와 같은 자료형들이 존재한다.
    
    int: 정수형
    bool: 논리 자료형
    string: UTF-8 인코딩 문자열
    bytes: 바이트
    address: 이더리움 주소값
    */
    uint dnaDigits = 16;

    // 아래와 같이 기본적인 사칙연산 외에도 지수 연산(10^16)도 가능하다.x2
    uint dnaModulus = 10 ** dnaDigits;

    /*
    struct 키워드를 사용해서 아래와 같이 구조체를 정의할 수도 있다.
    이때 string 자료형은 임의의 길이를 가진 UTF-8 데이터를 의미한다.
    */
    struct Zombie {
        uint dna;
        string name;
    }

    /*
    배열의 종류에는 크게 정적 배열과 동적 배열이 존재한다.
    정적 배열의 경우 고정 길이를 가진 배열을 의미하며 동적 배열은 고정된 크기 없이 계속 커질 수 있는 배열을 의미한다.

    구조체의 배열을 생성할 수도 있는데 구조체의 동적 배열을 생성하면 데이터베이스처럼 컨트랙트에 구조화된 데이터를 저장하는 데 사용된다.

    또한 컨트랙트에 공개 데이터를 저장할 때 public 키워드를 활용하여 다른 컨트랙트가 이를 읽을 수 있게 한다.
    해당 배열은 getter 메서드를 자동으로 생성한다.

    아래와 같이 배열을 만드는 방법 외에도 new 키워드를 활용해서 배열을 만들 수 있으며 이때는 길이 인자를 반드시 명시해줘야 한다.
    */
    Zombie[] public zombies;

    /*
    이벤트는 애플리케이션의 사용자 단에서 어떤 행동이 발생했을 때 컨트랙트가 블록체인 상에서 이와 의사소통하는 방법이다.
    컨트랙트는 특정 이벤트가 일어나는 지 확인하고 해당 이벤트가 발생하면 행동을 취한다.

    event 키워드를 사용하여 이벤트를 만들 수 있다.
    해당 이벤트는 자바스크립트에서의 이벤트리스너와 유사하다고 생각하면 된다.
    */
    event NewZombie(uint zombieId, string name, uint dna);

    /* 
    함수의 매개변수의 경우 언더스코어(_)로 시작을 하여 전역 변수와 구별하는 게 관례이다.
    이때 함수는 기본적으로 public으로 선언이 되어 있는데 private 키워드를 사용해서 private하게 바꿀 수 있다. (public인 경우도 명시적으로 작성을 해줘야 한다.)
    private은 컨트랙트 내의 다른 함수들만이 이 함수를 호출할 수 있다는 의미이다. 이때 관례적으로 함수명 앞에 언더스코어(_)를 붙인다.

    함수를 접근하는 방법은 public, private 외에도 internal 및 external 방법이 존재한다.
    internal 접근 제어자의 경우 private 접근 제어자와 유사하나 상속을 받은 컨트랙트, 다시 말해 자식 컨트랙트에서는 함수를 사용할 수 있게 한다.
    external 접근 제어자의 경우 컨트랙트의 외부에서만 호출할 수 있다.

    솔리디티에는 storage와 memory 개념이 존재한다. 이는 변수를 저장할 수 있는 공간을 의미한다.
    storage의 경우 블록체인 상에서 영구 저장되는 개념이며 memory의 경우 임시적으로 저장되어서 호출이 발생할 때마다 초기화된다.

    구조체와 배열을 선언할 때 명시적으로 선언해야 해서 아래 string 자료형의 _name이라는 변수에 memory 키워드를 사용했다.
    */
    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_dna, _name));
        // 기존에는 push() 메서드의 반환값이 해당 배열의 길이였지만 이제는 길이를 반환하지 않기 때문에 별도의 length 메서드를 따로 써줘야 한다.
        uint id = zombies.length - 1;
        /*
        emit 키워드를 사용하여 명시적으로 이벤트를 발생시키는 걸 알려준다.
        해당 코드를 통해 _createZombie() 함수가 실행되었을 때 아래 NewZombie() 실행된다.
        */
        emit NewZombie(id, _name, _dna);
    }

    /*
    함수에 반환값을 지정해주기 위해서는 returns 키워드를 사용해야 한다. 이때 함수 제어자의 종류로는 크게 view와 pure가 있다.
    view 함수의 경우 함수가 데이터를 보기만 하고 변경하지 않는다는 의미다.
    pure 함수의 경우 함수가 애플리케이션 내의 어떤 데이터도 접근하지 않는 것을 의미한다.
    */
    function _generateRandomDna(string memory _str) private view returns(uint) {
        /*
        이더리움은 SHA3의 한 버전인 keccak256를 내장 해시 함수로 가지고 있다.
        해시 함수는 기본적으로 입력 문자열을 무작위 256비트 16진수로 매핑하는데 조금의 변확만 존재하더라도 그 값이 크게 바뀐다.
        블로체인에서 안전한 의사 난수를 만드는 방법은 매우 어려운 문제 중 하나로 항상 주의해야 한다.

        이때 keccak256 내장 해시 함수는 인자로 bytes를 받아야 하기 때문에 abi.encode 메서드를 활용하여 string 자료형을 bytes로 변환하였다.
        */
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}