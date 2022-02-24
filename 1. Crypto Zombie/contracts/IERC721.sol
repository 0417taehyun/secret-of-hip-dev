// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

// ERC721를 준수하는 컨트랙트의 필수 인터페이스다.
interface IERC721 is IERC165 {

    // tokenId 라는 이름의 토큰이 from 으로부터 to 로 전송될 때 실행되는 이벤트다.
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // 소유자(owner)가 approved에게 tokenId 라는 토큰을 관리할 수 있게 승인해줬을 때 실행되는 이벤트다.
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    // 
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // owner 계정에 존재하는 토큰의 수를 반환한다.
    function balanceOf(address owner) external view returns (uint256 balance);

    // 
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // 
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;


    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;


    function approve(address to, uint256 tokenId) external;


    function getApproved(uint256 tokenId) external view returns (address operator);


    function setApprovalForAll(address operator, bool _approved) external;


    function isApprovedForAll(address owner, address operator) external view returns (bool);


    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}
