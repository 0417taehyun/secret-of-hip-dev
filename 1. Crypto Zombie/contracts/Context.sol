// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/*
아래는 OpenZeppelin에서 제공한 Contexxt Contract 코드다.
해당 코드에는 다음과 같은 설명이 덧붙여있다.

While these are generally available via msg.sender and msg.data,
they should not be accessd in such a direct manner,
since when dealing with meta-transactions the account sending and paying for execution may not be the actual sender (as far as application is concerned).

이를 번역해보면 다음과 같다.
아래와 같은 추상 컨트랙트를 만들고 함수를 별개로 만들지 않아도 단순히 msg.sender, msg.data를 통해 원하는 정보를 얻을 수 있음에도 불구하고
실제 메타 트랜잭션을 다룰 때 전달하고 지불하는 계정이 실행하는 계정과 다른 경우가 발생할 수 있기 때문에 아래와 같은 작업이 필요하다.

우선 메타 트랜잭션이 무엇인지 먼저 알아볼 필요가 있다.
메타 트랜잭션이란 실제 사용자가 가스를 지불하지 않는 트랜잭션으로 대납 처리되는 트랜잭션 내에 실질적인 트랜잭션 정보가 있기 때문에 정보에 대한 정보의 의미로서 '메타'라는 용어가 붙었다.
메타 트랜잭션의 등장 배경을 알면 조금 더 이해하기 쉽다. 사용자 입장에서는 사실 DApp을 사용하기 위해 그 모든 것에 대해 이해할 필요는 없다.
이런 사용자를 위해 등장한 게 바로 메타 트랜잭션인 것이다.
쉽게 말해 사용자는 일반적인 방식과 유사하게 트랜잭션을 만들고 자체 개인키로 서명하지만 체인이 아닌 대납자(Sender, Payer, Relayer ...)에게 그 트랜잭션을 전송한다.
이때 대납자는 도구일 수도, 서비스 또는 가스 요금을 지불하려는 사람일 수도 있다.

이런 상황에서 메타 트랜잭션을 다룰 때 결국 해당 트랜잭션을 실행하는 계정과 실제로 트랜잭션을 지불하는 계정이 다를 수 있다.
예를 들어 EIP-2771 같은 메타 트랜잭션 해결책을 사용할 때 실제 메시지 전달자와 msg.sender로 통해 얻게 되는 값은 다를 수 있다.

따라서 Context 컨트랙트의 _msgSender() 함수는 컨텍스트 내의 실제 메시지 전달자를 반환해준다.
*/
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}