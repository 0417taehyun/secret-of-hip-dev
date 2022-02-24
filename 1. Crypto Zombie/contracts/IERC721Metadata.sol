// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";

// ERC721의 표준 NFT에서 선택적인 메타데이터를 위한 확장 인터페이스다.
interface IERC721Metadata is IERC721 {

    // 토큰 컬렉션의 이름을 반환한다.
    function name() external view returns (string memory);

    // 토큰 컬렉션의 심볼을 반환한다.
    function symbol() external view returns (string memory);

    // 토큰의 tokenId에 대한 URI를 반환한다.
    function tokenURI(uint256 tokenId) external view returns (string memory);
}