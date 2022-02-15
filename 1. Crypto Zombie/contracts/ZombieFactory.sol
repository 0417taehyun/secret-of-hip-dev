/*
모든 솔리디티 소스 코드는 Version Pragma로 시작해야 한다.
이를 통해 솔리디티 버전을 선언하여 새로운 컴파일러 버전이 나와도 기존 코드가 깨지지 않게 한다.
이때 ^0.5.0과 같은 표기는 0.5.0 버전 이상의 모든 솔리디티의 코드가 컴파일 가능하다는 것을 의미한다.

또한 SPDX-License-Identifier를 첫 줄에 작성하여 컨트랙트가 라이선스를 함께 빌드할 수 있게 알려줘야 한다.
굳이 작성하지 않아도 되는, 오류가 아닌 주의사항이지만 0.6.8 버전 이후 생긴 방식이기 때문에 작성하는 걸 추천한다.
*/
// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

import "./Ownable.sol";

/*
솔리디티 코드는 컨트랙트 안에 싸여 있다.
컨트랙트는 이더리움 애플리케이션의 기본적인 구성 요소로 모든 변수와 함수는 어느 한 컨트랙트에 속해야 한다.
*/
contract ZombieFactory is Ownable {
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
    아래와 같이 years, weeks, days, hours, minutes, seconds 같은 시간 단위를 사용할 수 있다.
    해당 단위는 전부 uint 자료형인 초로 계산되어 변환된다. 다시 말해 1 hours의 값은 3600이다.
    */
    uint cooldownTime = 1 days;

    /*
    struct 키워드를 사용해서 아래와 같이 구조체를 정의할 수도 있다.
    이때 string 자료형은 임의의 길이를 가진 UTF-8 데이터를 의미한다.

    배열(Array)이 하나의 자료형에 대한 변수의 집합이라 한다면 구조체(Struct)는 다양한 자료형의 집합을 의미한다.
    */
    struct Zombie {
        uint dna;
        string name;

        /*
        DApp을 사용하기 위해서는 Gas를 지불해야 한다.
        Gas는 함수를 호출할 때 지불하게 되는데 함수의 로직이 얼마나 복잡한 지에 따라서 지불되는 양이 다르다.
        다시 말해 어떤 로직을 실행하기 위해 얼마 만큼의 컴퓨팅 파워가 필요한 지에 따라 Gas가 제출되는 것이다.
        이러한 맥락에서 코드의 최적화가 다른 프로그래밍 언어에 비해 무척 중요하다.
        왜냐하면 내가 만든 DApp을 사용자가 사용할 때 코드 최적화가 되어 있지 않으면 생각하지도 못한 프리미엄 비용을 추가로 내야 하기 때문이다.

        Gas 지출이 필요한 이유는 이더리움 상에서 DApp이 실행될 때 하나의 출력을 위해 다른 노드들이 전부 이것을 검증해줘야 하기 때문이다.
        물론 바로 이 부분을 통해 안전성과 탈중앙화라는 강점을 가져갈 수 있게 되었다.
        이더리움 제작자는 무한 루프를 통해 네트워크를 망가뜨리거나 집약적인 계산으로 네트워크 리소스를 낭비하게 하고 싶지 않았기 때문에 Gas 비용을 지불하게 했다.

        물론 이더리움 메인넷 외에도 룸 네트워크(Loom Network)와 같은 다양한 네트워크가 존재하여 Gas 비용에 대한 부분이 다 다를 수 있다.
        여기서 메인넷이란 블록체인을 실제 출시하여 운영하는 네트워크를 의미한다.
        */

        /*
        원래 솔리디티는 uint 자료형의 서브 자료형에 상관 없이 스토리지에 전부 256 비트로 저장하기 때문에 uint나 uint32나 무엇을 사용해도 크게 문제가 없다.
        그러나 구조체를 만들 경우 다수의 uint가 구조체 내에 존재할 때 문제가 된다.
        구조체 내부에 uint 자료형이 차지하는 크기 만큼 결국 구조체의 크기가 더 커지게 되고 이는 곧 Gas 비용의 증가를 의미하기 때문이다.
        따라서 uint32와 같이 정확한 크기의 자료형을 정의해주는 것이 중요하며 아래 예시와 같이 서브 자료형을 이어서 써주는 것이 메모리 절약에 더 효율적이고, 결과적으로 Gas 비용도 덜 나간다.
        왜냐하면 uint32, uint, uint32 순서로 구조체를 정의할 경우 uint32 만큼의 크기 이후 빈 공간에 uint 자료형이 차지할 공간이 없어 새로운 공간을 할당 받아야 하지만
        uint, uint32, uint32 순서로 구조체를 정의할 경우 uint32 만큼의 크기가 할당된 이후 빈 공간에 uint32 자료형을 연속해서 할당할 수 있기 때문에 더 효율적이다.
        */
        uint32 level;
        uint32 readyTime;
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

    event 키워드를 사용하여 이벤트를 만들 수 있다. 해당 이벤트는 자바스크립트에서의 이벤트리스너와 유사하다고 생각하면 된다. 이때 중요한 점은 본문을 구현하지 않아야 한다는 것이다.

    프론트엔드 코드에서는 Socket 이벤트를 초리하는 것처럼 해당 이벤트에 대한 콜백 코드를 작성하면 된다.
    예를 들어 아래와 같은 NewZombie() 이벤트는 프론트엔드 상에서 다음과 같이 처리할 수 있다.

    Contract.NewZombie((error, response) => {
        console.log(response); // > response 출력
    })
    */
    event NewZombie(uint zombieId, string name, uint dna);

    /*
    address 객체는 은행 계좌와 동일하다고 생각하면 편하다. 따라서 개별 사용자별로 고유한 계정인 address 객체를 가지고 해당 address를 통해 Ether를 주고 받을 수 있다.
    mapping의 경우 key-value 형태의 자료형을 의미하며 앞에 정의한 자료형이 key가 되고 뒤에 정의한 자료형이 value가 된다.
    */
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    /* 
    함수의 매개변수의 경우 언더스코어(_)로 시작을 하여 전역 변수와 구별하는 게 관례이다.
    이때 함수는 기본적으로 public으로 선언이 되어 있는데 private 키워드를 사용해서 private하게 바꿀 수 있다. (public인 경우도 명시적으로 작성을 해줘야 한다.)
    private은 컨트랙트 내의 다른 함수들만이 이 함수를 호출할 수 있다는 의미이다. 이때 관례적으로 함수명 앞에 언더스코어(_)를 붙인다.

    함수를 접근하는 방법은 public, private 외에도 internal 및 external 방법이 존재한다.
    internal 접근 제어자의 경우 private 접근 제어자와 유사하나 상속을 받은 컨트랙트, 다시 말해 자식 컨트랙트에서는 함수를 사용할 수 있게 한다.
    external 접근 제어자의 경우 컨트랙트의 외부에서만 호출할 수 있다.

    네 키워드의 차이점을 다시 한 번 설명하면 다음과 같다.
    public 함수의 경우 함수가 포함된 컨트랙트 내부 뿐만 외부인 다른 콘트랙트에서도 사용할 수 있다.
    private 함수의 경우 함수가 포함된 컨트랙트 내에서만 해당 함수를 사용할 수 있다.
    external 함수의 경우 해당 함수가 포함된 내부 컨트랙트에서는 호출이 불가능하고 외부에서만 해당 함수를 호출할 수 있다.
    internal 함수의 경우 해당 함수가 포함된 내부 컨트렉트와 그 컨트랙트를 상속 받은 자식 컨트랙트에서만 사용 가능하다.

    솔리디티에는 storage와 memory 개념이 존재한다. 이는 변수를 저장할 수 있는 공간을 의미한다.
    storage의 경우 블록체인 상에서 영구 저장되는 개념이며 memory의 경우 임시적으로 저장되어서 호출이 발생할 때마다 초기화된다.
    구조체와 배열을 선언할 때 명시적으로 선언해야 해서 아래 string 자료형의 _name이라는 변수에 memory 키워드를 사용했다.
    아래는 공식 문서에 나온 EVM(Ethereum Virtual Machine)의 데이터 저장 공간 내용이다.

    The Ethereum Virtual Machine has three areas where it can store data - storage, memory and the stack, which are explained in the following paragraphs.

    Each account has a data area called storage, which is persistent between function calls and transactions.
    Storage is a key-value store that maps 256-bit words to 2560bit words.
    It is not possible to enumerate storage from within a contract, it is comparatively costly to read, and even more to initialise and modify storage.
    Because of this cose, you should minimize what you store in persistent storage to what the contract needs to run.
    Store data like derived calculations, caching, and aggregates outside of the contract.
    A contract can neither nor write to any storage apart from its own.

    The second data is called memory, of which a contract obtains a freshly cleared instance for each message call.
    Memory is linear and can be addressed at byte level, but reads are limited to a width of 256 bits, while writes can be either 8 bits or 256 bits wide.
    Memory is expanded by a word (256-bit), when accessing (either reading or writing) a previously untouched memory word (i.e. any offset within a word).
    At the time of expansion, the cost in gas must be paid. Memory is more costly the larger it grows (it scales quadratically).

    The EVM is not a register machine but a stack machine, so all computations are performed on a data area called the stack.
    It has a maximum size of 1024 elements and contains words of 256 bits.
    Access to the stack is limited to the top end in the following way: It is posiible to copy one of the tompost 16 elements below it.
    All other operations take the topmost two (or one, or more, depending on the operation) elements from the stack and push the result onto the stack.
    Of course it is possible to move stack elements to storage or memory in order to get deeper access to the stack,
    but it is not possible to just access arbitrary elements deeper in the stack without first removing the top of the stack.
    Of course it is possible to move stack elements to storage or memory in order to get deeper access to the stack,
    but it is not possible to just access arbitrary elements deeper in the stack without first removing the top of the stack.

    요약하자면 다음과 같다.
    Storage의 경우 함수 호출과 트랜잭션 사이에서 영구적인 데이터 영역이다. 다시 말해 블록체인에 존재하는 상태 변수이다.
    Memory의 경우 각 메세지 호출 때마다 컨트랙트가 얻게 되는 새로운 인스턴스다. 다시 말해 함수가 불러진 동안만 메모리에 존재하는 지역변수라 생각하면 편하다.
    Stack은 EVM 자체가 스택 기반의 머신이기 때문에 내부적으로 처음 올라가는 메모리다.

    이외에도 Calldata 종류가 존재하는데 외부함수로만 이용이 가능하다. memory와 유사하다.
    */
    function _createZombie(string memory _name, uint _dna) internal {
        /*
        이전에는 now 메서드를 통해 블록의 현재 시각을 얻을 수 있었지만
        이제는 block.timestamp 메서드를 사용하여 Unix Timestamp 값을 얻을 수 있다.
        또한 아래 코드와 같이 다른 시간 값, 예를 들어 days, minutes 등과의 사칙연산이 가능하다.

        물론 아래와 같이 uint32 자료형을 사용하여 32비트 정수형으로 타임스탬프를 사용할 경우 2038 문제가 발생할 수 있다.
        다시 말해 2038년에 사인 비트의 값이 변화되어 음수로 바뀌면서 원하는 값이 안 나올 수 있다. 즉 오버플로우가 발생한다는 것이다.
        따라서 uint64를 사용할 수도 있지만 사용자는 그만큼 Gas를 더 지불해야 한다.
        */
        zombies.push(Zombie(_dna, _name, 1, uint32(block.timestamp + cooldownTime)));

        // 기존에는 push() 메서드의 반환값이 해당 배열의 길이였지만 0.6.0 버전 이후 길이를 반환하지 않기 때문에 별도의 length 메서드를 따로 써줘야 한다.
        uint id = zombies.length - 1;

        /*
        솔리디티에는 모든 함수에서 사용할 수 있는 글로벌 변수 msg.sender가 존재한다. 이때 msg.sender는 해당 함수를 호출한 사용자의 address 객체를 반환한다.
        솔리디티에서 함수를 실행시키기 위해서는 반드시 외부의 호출이 필요하다. 따라서 누군가 해당 함수를 호출하지 않는 경우 콘트랙트는 블록체인 내부에서 계속 대기하고 있게 된다.

        msg.sender는 블록체인의 보안과 연결되어 있다. 누군가 다른 사람의 데이터를 변경하는 유일한 방법은 이더리움 주소와 연관된 비밀 키를 훔치는 방법 뿐이다.
        */
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

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

    또한 require 조건문을 통해서 참인 경우에만 함수를 실행할 수 있다.
    예를 들어 아래 코드에 require(_str == "Test"); 라는 구문을 추가할 경우 해당 함수의 매개변수로 전달 받은 _str의 값이 Test일 때만 함수가 실행된다.

    그리고 값을 반환할 때 return (10, 20, 30); 과 같이 여러 값을 한 번에 반환할 수 있는데 이때 아래와 같이 원하는 값만 전달 받을 수 있다.
    
    uint number;
    (, , number) = func();

    이때 number의 값은 반환되는 (10, 20, 30) 중 세 번째 요소를 전달 받기 때문에 30이 된다.
    */
    function _generateRandomDna(string memory _str) private view returns(uint) {
        /*
        이더리움은 SHA3의 한 버전인 keccak256를 내장 해시 함수로 가지고 있다.
        해시 함수는 기본적으로 입력 문자열을 무작위 256비트 16진수로 매핑하는데 조금의 변확만 존재하더라도 그 값이 크게 바뀐다.
        블로체인에서 안전한 의사 난수를 만드는 방법은 매우 어려운 문제 중 하나로 항상 주의해야 한다.

        이때 keccak256 내장 해시 함수는 인자로 bytes를 받아야 하기 때문에 abi.encode 메서드를 활용하여 string 자료형을 bytes로 변환하였다.

        abi.encode 외에도 abi.encodePAcked, abi.encodeWithSignature, abi.encodeWithSelector와 같이 3개의 종류가 더 존재한다.
        각각의 차이점은 언급하기 이전 ABI(Application Binary Inteface)에 관해 먼저 알아볼 필요가 있다.

        ABI는 두 프로그램 모듈의 인터페이스 역할을 하고 하나는 기계어 레벨에 존재하여 데이터를 기계어로 인코딩/디코딩하기 위해 존재한다.
        이더리움에서 EVM을 통해 컨트랙트를 호출할 때 인코딩을 하거나 트랜잭션으로부터 데이터를 읽을 때 사용한다.
        
        또한 ABI는 컨트랙트 내의 함수를 호출하거나 컨트랙트로부터 데이터를 얻는 방법이다.
        이더리움 스마트 컨트랙트는 이더리움 블록체인에 배포된 바이트코드로 컨트랙트 내에 여러 개의 함수가 존재하기 때문에 ABI가 어떤 함수를 호출할 지 지정하는데 필요하다.
        이는 개발자가 생각한 대로 함수가 데이터를 반환하는 결과를 보장하기 위해서 반드시 필요하다.

        해당 네 메서드의 차이점은 아래와 같다.
        abi.encode 메서드의 경우 매개변수로 ABI 스펙을 사용한다. 따라서 주로 컨트랙트를 호출할 때 사용한다.
        abi.encodePacked 메서드의 경우 컨트랙트를 호출하지 않고 매개변수가 자료형에 맞춰 필요한 최소한의 공간만을 사용한다.
        abi.encodeWithSignature 메서드의 경우 abi.encode 메서드와 유사하지만 첫 번째 매개변수로 함수의 서명을 전달 받는다. 선택자를 계산하길 원하지 않고 해당 서명을 알고 있을 때 사용한다.
        abi.ecnodeWithSelector 메서드의 경우 abi.encode 메서드와 유사하지만 첫 번째 매개변수로 선택자를 전달 받는다. abi.encodeWithSignature 메서드와 매우 유사하다.

        앞서 여러 개의 함수가 존재하기 때문에 ABI를 활용하여 어떤 함수를 호출할 지 지정한다고 언급했다. 솔리디티에서는 함수 선택자를 이용하여 함수를 구별한다.
        함수 서명의 keccak256 해시값의 앞 4바이트 calldata를 의미하며 해당 부분을 통해 함수를 구별할 수 있다.
        이때 값이 충돌하는 경우 오류를 반환하고 어떠한 바이트코드로 생성하지 않아서 컴파일러 단에서 함수 선택자가 겹치지 않음을 보장해준다.
        함수는 함수의 이름과 매개변수의 자료형을 통해 Keccak-256 알고리즘을 사용하여 해싱되는데 해당 부분을 통해 생성된 앞 4바이트가 곧 함수의 서명이며 동시에 함수의 선택자이다.

        예를 들어 아래 createRandomZombie() 함수의 경우 함수이름인 createRandomZombie 및 매개변수로 전달되는 자료형 string이 해싱값으로 사용된다.
        createRandomZombie(string)이 keccak-256 알고리즘을 통해 해싱되어 7bff0a01...와 같은 값을 만들고 4바이트 값인 7bff0a01이 함수의 서명이자 선택자로 사용된다.
        컴파일링된 바이트코드를 ZombieFactory.json 파일에서 확인해보면 7bff0a01 바이트코드가 존재하는 걸 확인해볼 수 있다.
        */
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);

        /*
        require은 if 조건문과 유사하게 조건을 통해 해당 조건이 참인지 판별하는 구문이지만 에러 핸들링에 더 가깝다.
        왜냐하면 if 조건문을 사용할 경우 만약 조건이 거짓이면 다음 구문으로 넘어가서 프로그램이 계속 실행되지만 require은 오류를 일으키기 때문이다.
        */
        require(ownerZombieCount[msg.sender] == 0);

        _createZombie(_name, randDna);
    }
}
