// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
ERC165 표준의 인터페이스다. 
이때 구현자는 ERC165Checker와 같은 다른 것으로부터 쿼리가 될 수 있게 컨트랙트 인터페이스의 지원 부분을 선언할 수 있다.
*/
interface IERC165 {

    /*
    이 컨트랙트가 interfaceId로 정의된 인터페이스를 구현했을 경우에 true를 반환한다.
    아래 함수는 30,000 가스보다 적은 비용을 사용하여 호출해야 한다.
    */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}