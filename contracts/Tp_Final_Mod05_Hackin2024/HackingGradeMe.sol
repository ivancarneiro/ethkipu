// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGrader {
    function retrieve() external payable;
    function retrieve2() external payable;
    function mint(address to) external;
    function gradeMe(string calldata name) external;
    function balanceOf(address owner) external view returns (uint256);
}

// Pasos para obtener 100 puntos.
// 1. Desplegar el contrato HakingGradeMe pasando como parámetro la dirección del contrato publicado por ETH.Kipu 0x6F14A55C82600DCAFeb1841243a15921DCD10aF7

// 2. Una vez desplegado HakingGradeMe, desde el contrato llamar a la funcion executeRetrieve2() DOS VECES, en cada llamada NO TE OLVIDES DE ENVIAR 5 Wei. 
// Esto incrementara el contador del contrato en 2, lo que te permitirá mintear un NFT.

// 3. Llamar a la funcion executeMint() pasando la dirección de tu wallet como parámetro para que reciba el NFT. 
// Esto hará que el balanceOf de la wallet sea 1, requisito indispensable para luego poder llamar a graderMe con esa Wallet directamente desde Hacking2024. PERO NO TE APRESURES...

// 4. Todavía desde el contrato HackingGradeMe, llamar a la funcion executeRetrieve() pasando 5 wei, 
// esto es CRUCIAL para la variable "foo" de la wallet, con esto foo(tx.origin) == 1, otro requisito indispensable para luego poder llamar a graderMe.

// 5. ÚLTIMO PASO. Ahora ve directamente al contrato publicado por ETH.Kipu https://sepolia.etherscan.io/token/0x6F14A55C82600DCAFeb1841243a15921DCD10aF7
// o importalo desde RemixIDE e iteractua con la misma wallet.
    // a. Comprueba el valor de "foo" de tu wallet.
    // b. Comprueba el "balanecOf" de tu wallet.
    // Si cumples las condiciones ahora llama al gradeMe() pasando tu nombre o aleas.

// FELICIDADES HAS OBTENIDO 100 PUNTOS!!!


contract Hacker {
    IGrader public grader;

    constructor(address _graderAddress) {
        grader = IGrader(_graderAddress);
    }

    function executeRetrieve() external payable {
        grader.retrieve{value: 5 wei}();
    }

    function executeRetrieve2() external payable {
        grader.retrieve2{value: 5 wei}();
    }

    function executeMint(address to) external {
        grader.mint(to);
    }

    // Funciones para recibir Ether
    receive() external payable {}
    fallback() external payable {}
}
