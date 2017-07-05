var PToken = artifacts.require("./PToken.sol");
var Voting = artifacts.require("./Voting.sol");

module.exports = function(deployer) {
  deployer.deploy(PToken);
  deployer.deploy(Voting);
};