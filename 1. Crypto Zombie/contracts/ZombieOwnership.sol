// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./SafeMath.sol";
import "./ZombieAttack.sol";


/*
솔리디티에서 주석을 남기는 방식은 natspec을 따른다.
아래 공식 문서를 확인하면 편하다.
https://docs.soliditylang.org/en/latest/natspec-format.html

원래 ERC20 토큰을 사용하여 transferFrom 등의 정형화된 메서드를 사용한다.
그러나 해당 토큰은 0.027과 같이 세부적으로 나뉠 수 있는데 만약 좀비와 같이 하나의 유닛으로 교환하고 해당 유닛이 상대적으로 값이 다른 경우 다른 토큰 정책이 필요하다.
보통 이럴 때 사용하는 게 ERC721이다.

이떼 ERC는 Ethereum Request for Comment의 약자로 RFC(Request For Comment)의 경우 인터넷 기술에 대해 새로운 기술을 제시하고 비평을 받기 기다리는 문서를 뜻한다.
다시 말해 ERC는 이더리움(Ethereum)과 관련된 새로운 기술을 제시하는 문서이다. 그리고 다른 사람의 의견에 따라 표준이 될 수도 있다.
*/
contract ZombieOwnership is ZombieAttack, ERC721 {

    // 라이브러리는 다음과 같이 선언하여 사용할 수 있다.
    using SafeMath for uint256;

    mapping (uint => address) zombieApprovals;

    /*
    원래 balanceOf는 남아 있는 토큰의 양을 반환한다.
    여기서 토큰은 곧 좀비를 의미하기 때문에 좀비의 수를 반환하는 ownerZombieCount 매핑을 활용한다.

    이때 uint256 자료형은 uint와 동일하다.
    */
    function balanceOf(address _owner) external view returns (uint256) {
        return ownerZombieCount[_owner];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {

        /*
        이때 using을 사용한 선언 방식을 통해 아래와 같이 owenrZombieCount의 값을
        자동적으로 함수의 첫 번째 인자로 전달해줄 수 있다.
        */
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    /*
    원래 ownerOf는 토큰의 주인을 반환한다.
    여기서 토큰은 곧 좀비이고 _tokenId는 곧 _zombieId를 의미하기 때문에 zombieToOwner 매핑을 활용한다.

    기존 ZombieFeeding.sol 파일 내부에 modifier로 ownerOf가 존재했다.
    ERC721를 상속 받아 사용하기 때문에 기존의 modifier인 ownerOf의 이름을 onlyOwenrOf로 바꾸고 이를 사용하던 함수들에 쓰여있던 이름도 바꿔야 한다.
    */
    function ownerOf(uint256 _tokenId) external view returns (address) {
        return zombieToOwner[_tokenId];
    }


    function transferFrom(address _from, address _to, uint _tokenId) external payable {
        require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }


    function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sedner, _approved, _tokenId);
    }
}