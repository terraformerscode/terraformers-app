// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestTerraOne is ERC20, Ownable {

    constructor(uint256 initialSupply) ERC20("TestTerraOne", "TTONE") {
        _mint(msg.sender, initialSupply);
    }
    
    // 1 ETH = 1000000000000000000 wei!

    // const instance = await TestTerraOne.deployed()
    // instance.balanceOf(address(this))
    // instance.balanceOf("0x76a49f21CA535F0114eaFC351F06A41C41991aD9").then(function(balance) { balanceInstance = balance})
    // instance.balanceOf("0x2E6CBD1768f2F8fa27BFE9889Ff19D8120B7BBFa")
}