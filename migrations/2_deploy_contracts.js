// var ConvertLib = artifacts.require("./ConvertLib.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");'
var Organisation = artifacts.require("./Organisation.sol");


module.exports = function(deployer) {
    deployer.deploy(Organisation);
};
