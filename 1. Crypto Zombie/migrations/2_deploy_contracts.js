const Zombie = artifacts.require("Zombie");

module.exports = function (deployer) {
  deployer.deploy(Zombie);
};
