// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

/*
IERC165 인터페이스의 구현체다.
ERC165를 구현하고 싶은 컨트랙트의 경우 아래와 같이
이 컨트랙트를 상속 받고 지원될 추가적인 인터페이스 아이디를 확인하기 위해 supportsInterface를 오버라이드 해야 한다. 

function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
}

대안책으로 ERC165Storage가 더 쉬운 방법을 제공하지만 구현하는 데 훨씬 비싸다.
*/
abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}