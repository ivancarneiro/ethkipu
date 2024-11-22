// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TokenA
 * @dev Implementation of the first token for the SimpleDEX
 * Inherits from OpenZeppelin's ERC20 implementation
 */
contract TokenA is ERC20, Ownable {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens
     * Mints 10 thousand tokens with 18 decimals to the contract deployer
     */
    constructor() 
        ERC20("TokenA", "TKA") 
        Ownable(msg.sender) {
        _mint(owner(), 1000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}