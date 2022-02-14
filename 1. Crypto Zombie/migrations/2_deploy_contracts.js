/*
artifacts.require() 메서드를 통해 컨트랙트의 정보를 획득한다.
이때 파일 이름이 아닌 해당 컨트랙트의 이름을 사용해야 한다.
*/
const ZombieFactory = artifacts.require("ZombieFactory");

module.exports = function (deployer) {
  /*
  deployer.deploy() 메서드를 통해 해당 컨트랙트를 배포한다.
  다시 말해 해당 파일을 통해 Migrations에 작성된 컨트랙트를 배포할 수 있다.
  */
  deployer.deploy(ZombieFactory);
};
