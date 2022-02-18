// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
아래는 Truffle 공식 문서에 작성되어 있는 Migrations에 관한 설명이다.

Migrations are JavaScript files that help you deploy contracts to the Ethereum network.
These files are responsible for deployments tasks, and they're written under the assumption that your deployments needs will change over time.

현재 네트워크 상에 어떤 마이그레이션이 완료되었는 지 추적하는 역할을 담당한다고 짧게 요약해볼 수 있다.

아래는 Stackoverflow에 작성된 추가적인 설명이다.

The Migrations contract stores (in last_completed_migration) a number that corresponds to the last applied "migration" script, found in the migrations folder.
Deploying this Migrations contract is always the first such step anyway.
The numbering convertion is x_script_name.js, with x starting at 1.
Your real-meat contracts would typically come in scripts starting at 2_ ...

So, as this Migrations contract stores the number of the last deployments script applied, Truffle will not run those scripts again.
On the other hand, in the future, your app may need to have a modified, or new, contract deployed.
For that to happen, you create a new script with an increased number that describes the steps that need to take place.
Then, again, after they have run once, they will not run again.

number_script_name.js와 같은 형태의 파일 컨벤션을 통해서 순서대로 마이그레이션이 진행되는데 해당 번호를 기억하여 Truflle은 이미 진행한 컨트랙트에 대해 또다시 마이그레이션을 실행하지 않는다.

결론적으로 Migrations 컨트랙트를 통해 스마트 컨트랙트의 마이그레이션을 관찰하고 변경되지 않은 컨트랙트에 대해서 이중 마이그레이션이 되지 않게 관리한다.
*/
contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
