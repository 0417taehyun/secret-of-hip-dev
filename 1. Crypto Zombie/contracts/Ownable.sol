// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

import "./Context.sol";

abstract contract Ownable is Context {
    address private _owner;
    
    // 만약 솔리디티에서 로그를 출력해보고 싶다면 event log 및 emit log를 사용하면 된다.
    
    /*
    특정한 이벤트의 값만 가져올 때 indexed 키워드를 사용한다. 예를 들어 다음과 같다.
    web3.js를 사용한 프론트엔드 코드에서 getPastEvents() 메서드를 활용하여 지난 이벤트를 조회할 수 있다. 그 코드는 아래와 같다.

    getPastEvents("eventName", { filter: { number: [1, 2] }, fromBlock: 1, toBlock: "latest" });

    eventName이라는 event를 통해서 number의 값이 1 또는 2인 블록을 첫 번째 블록부터 가장 최신의 블록까지 조회하겠다는 의미다.
    이때 indexed를 사용하지 않은 경우 number의 값과 상관 없이 모든 블록이 반환되고 indexed number를 통해 설정한 이벤트일 경우 number의 값이 1과 2인 블록만 반환된다.
    */
    event OwenerShipTransferred(address indexed previousOwner, address indexed newOwner);

    /*
    솔리디티는 객체 지향 언어이기 때문에 객체의 초기화를 위한 생성자를 위해 constructor() 키워드가 존재한다.

    생성자의 특징은 다음과 같다.
    1. 생성자는 컨트랙트가 배포될 때 호출된다.
    2. 생성자는 필수로 작성하지 않아도 되지만 사용할 때는 단 1개의 생성자만 써야 한다.
    3. 생성자를 직접 작성하지 않으면 기본 생성자(Default Constrcutor)가 자동으로 생성된다.
    
    아래 생성자를 통해 Ownable 컨트랙트가 배포될 때 해당 컨트랙트의 소유자를 초기에 저장하기 위해
    _transferOwnship() 함수가 호출되고 OwnerShipTransfered 이벤트가 호출된다.
    */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /*
    해당 컨트랙트의 소유자를 반환받는 함수다.
    메타 트랜잭션으로 인해 트랜잭션 소유권 불일치를 확인하기 위해 _msgSender() 함수와 비교하게 된다.
    */     
    function owner() public view virtual returns (address) {
        return _owner;
    }
    
    /*
    modifier는 함수의 작동을 변경시키기 위해 사용된다.
    modifier를 사용하여 함수를 실행하기 전과 후에 특정한 기능을 하도록 만들 수 있는데 이를 통해 사전에 어떤 조건에 부합되는 지 확인이 가능하다.
    그래서 주로 소유권과 같은 부분, 계정이 동일한 지 함수를 실행하기 전에 확인하는데 사용된다.
    쉽게 파이썬의 데코레이션과 유사하다고 생각하면 편하다.

    따라서 아래 onlyOwner의 경우 해당 컨트랙트의 배포 계정만 실행할 수 있도록 제한한다.
    만약 그렇지 않으면 "Ownable: caller is now owner"를 반환한다.
    이때 modifier 내부의 언더스코어(_;) 부분이 바로 함수가 실행하는 시점을 의미한다.

    require() 메서드의 경우 두 번째 인자는 사용자가 받아볼 수 있는 오류 메시지다.
    */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not owner");
        _;
    }
 
    /*
    modifier onlyOwner()를 통해 소유 여부를 우선 확인한 뒤 만약 해당 소유자일 경우 소유권을 파기하는 함수다.
    소유권을 포기하기 때문에 소유자 없이 컨트랙트가 종료되며 소유자만 사용할 수 있던 모든 기능이 제거된다.
    */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /*
    modifier onlyOwner()를 통해 소유 여부를 우선 확인한다.
    그리고 만약 해당 컨트랙트의 소유자가 맞을 경우 소유권을 포기하지 않았는 지 확인한다.
    소유권을 포기했다면 "Ownalbe: new owner is the zero address"를 반환하다.
    정상적으로 본인이 소유한 컨트랙트인 경우 소유권을 새로운 소유자에게 이전한다.
    */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /*
    아래가 실제로 소유권 이전이 행해지는 내부 함수 _transferOwnerhsip()이다.

    새로운 소유자로 소유권을 이전하고 소유권이 이전되었음을 OwnershipTransferrred 이벤트를 emit 한다.
    */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwenerShipTransferred(oldOwner, newOwner);
    }
}