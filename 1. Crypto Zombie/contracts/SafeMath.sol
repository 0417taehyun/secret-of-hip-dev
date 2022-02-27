// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {

    /*
    산술작업은 언더플로우와 오버플로우 상황에서 되돌릴 수 있는데,
    unchecked를 사용하여 이전에 수행하던 확인 부분을 감싸 표현할 수 있다.

    솔리디티는 0.8 버전 이후부터 내부적으로 자체 언더플로우, 오버플로우 확인 작업을 해주고
    오류가 발생할 경우 이를 되돌려준다.

    결국 이전에는 내부적으로 구현이 안 되어 있어 라이브러리 SafeMath를 만들고 구현하던 것들을
    사용할 필요가 없다는 의미인데 혹시 사용하고 싶다면 unchecked 키워드를 통해 사용할 수 있다는 의미다.

    추가적으로 기존의 if 구문 등을 통해서 직접 작업하는 것에 비해 unchecked를 사용할 경우 가스 비용을 절약할 수 있다.

    require과 비슷한 역할을 하는 키워드로 assert가 존재한다.
    require의 경우 만약 조건을 충족하지 못했을 때 가스 비용을 사용자에게 반환해주지만
    assert의 경우 문제가 발생해도 가스 비용을 반환해주지 않는다.

    따라서 대부분의 조건에 대해서는 require을 사용하는 게 좋으며
    언더 및 오버플로우와 같은 매우 심각한 문제가 발생하는 경우를 확인할 때만 사용하는 게 좋다.
    */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }


    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
}