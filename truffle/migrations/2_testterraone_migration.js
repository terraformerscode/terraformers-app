const TestTerraOne = artifacts.require("TestTerraOne");

module.exports = function (deployer) {
  // 1 bil tokens, 18 decimals
  deployer.deploy(TestTerraOne, 1000000000);
  
};
