const TestTerraTwo = artifacts.require("TestTerraTwo");

module.exports = function (deployer) {
  // 10,000 tokens, 18 decimals
  deployer.deploy(TestTerraTwo, 10000000000000000000000n);
  
};
