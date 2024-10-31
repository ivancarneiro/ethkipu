// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;
/*
Emitir un evento DonacionRealizada que incluya:
La dirección del donante.Programa
La cantidad de ether donada.
La fecha de la donación.
*/
contract Donaciones {

//1)
    mapping(address => uint256) public balance; //Utilizar un mapping para rastrear el total donado por cada dirección.

    struct Donacion {
        address donante; // la dirección del donante.
        uint256 cantidad; // la cantidad de ether donada.
        uint256 fecha; // la fecha de la donación.
    }

    Donacion[] public donaciones; //Crear un array de Donacion para almacenar todas las donaciones realizadas al contrato.

    address[] public uniqueAddr;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    /*2)
    Emitir un evento DonacionRealizada que incluya:
    La dirección del donante.
    La cantidad de ether donada.
    La fecha de la donación.
    */
    event DonacionRealizada(address indexed donante, uint256 donacion, uint256 fecha);

/*
3) Una función donar() que permita a los usuarios enviar ether al contrato. Esta función debe:
Aceptar ether (debe ser payable).
Crear un nuevo registro en el array de donaciones.
Actualizar el mapping para reflejar el total donado por el donante.
Emitir el evento DonacionRealizada.
*/
    function donar() external payable {
        address _sender = msg.sender;
        donaciones.push(Donacion(_sender,msg.value, block.timestamp));
        if(balance[_sender]==0) {
            uniqueAddr.push(_sender);
        }
        balance[_sender] +=  msg.value;
        emit DonacionRealizada(_sender, msg.value, block.timestamp);
    }

/*
Una función obtenerDonaciones() que retorne el total de donaciones realizadas 
y el número de donantes únicos.
*/
    function obtenerDonaciones() external view returns (Donacion[] memory _donaciones) {
        uint256 len = uniqueAddr.length;
        for(uint256 i=0; i< len; i++) {
            _donaciones[i] = Donacion(uniqueAddr[i],balance[uniqueAddr[i]],block.timestamp);
        }
        return _donaciones;
    }

/*
Una función retirarFondos() que permita al propietario del contrato retirar los fondos acumulados. Esta función debe:
Validar que el llamador sea el propietario.
Transferir el ether acumulado a la dirección del propietario utilizando address payable.
*/

    modifier onlyOwner() {
        require(msg.sender ==owner, "usted no tiene permisos");
        _;
    }

    function retirarFondos() external onlyOwner{
        payable(msg.sender).transfer(address(this).balance); // address.balance
    }

}