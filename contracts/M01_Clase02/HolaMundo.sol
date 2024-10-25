// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract HolaMundo {

    string nombre;
    address direccion;
    string mensaje;
    uint256 fecha;

    function verUltimaVisita() external view returns (string memory, address, string memory, uint256) {
        return (nombre, direccion, mensaje, fecha);
        }

    function escribirVisita(string memory _nombre, string memory _mensaje) external {
        nombre = _nombre;
        direccion = msg.sender;
        mensaje = _mensaje;
        fecha = block.timestamp;
    }
}