// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC721 자산 컨트랙트로부터 safeTransfer를 지원하길 원하는 컨트랙트를 위한 인터페이스로 ERC721 토큰을 수신하는 수신자 인터페이스다.
interface IERC721Receiver {
    
    /*
    from으로부터 operator에 의해 IERC721의 tokenId가 IERC721-safeTransferFrom을 거쳐 이 컨트랙트로 전달되었을 때 아래 함수가 호출된다.
    그리고 함수의 호출 결괏값으로 토큰 전송자를 확인하기 위해 솔리디티 선택자(selector)를 반환한다.
    만약 다른 값을 반환하거나 인터페이스가 아래처럼 구현되지 않는다면 전송이 revert 된다.
    선택자는 IERC721Receiver.onERC721Recived.selecotr를 통해 획득할 수 있다.
    */
    function onERC721Recived(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}