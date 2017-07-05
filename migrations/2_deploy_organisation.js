var MembersLibrary = artifacts.require("./MembersLibrary.sol");
var ProjectsLibrary = artifacts.require("./ProjectsLibrary.sol");
var TasksLibrary = artifacts.require("./TasksLibrary.sol");
var Organisation = artifacts.require("./Organisation.sol");

module.exports = function(deployer) {
  deployer.deploy(MembersLibrary);
  deployer.deploy(ProjectsLibrary);
  deployer.deploy(TasksLibrary);
  deployer.link(MembersLibrary, Organisation);
  deployer.link(ProjectsLibrary, Organisation);
  deployer.link(TasksLibrary, Organisation);
  deployer.deploy(Organisation);
};