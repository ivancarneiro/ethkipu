// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/* CONSIGNAS
    - INICIALIZACIÓN:
        - Definir valor mín de inicio. *
        - Definir fecha/hora inicio. *
        - Definir duración de subasta. *
        - Definir saltos mínimos entre pujas. *
        - Definir tiempos de extensión por pujas nuevas.

    - Ejecución Subasta
        Minetras Subasta Activa...
            BID --> ofertaNueva -->
                If (ofertaNueva > precioActual){
                    mejorOferta = ofertaNueva;
                    mejorBidder = ultBidder;
                    masTiempo(extiende el tiempo de la subasta);
                }
                Esle {
                    "Oferta nueva desetimada.";
                }

        Asignación:
            - Tiempo concluído == true.
            - Transferir importe final al vendedor.
            - Transferir premio al ganador.
*/

contract Bid {
    
    
    uint256 initValue;
    uint256 beginTimestamp;
    uint256 duration;
    uint256 bidIncrement;
    uint256 extTime;
    uint256 finishTimestamp;

    constructor(uint256 _initValue, uint256 _beginTimestamp, uint256 _duration, uint256 _bidIncrement, uint256 _extTime){
        initValue = _initValue;
        beginTimestamp = _beginTimestamp;
        duration = _duration;
        bidIncrement = _bidIncrement;
        extTime = _extTime;
        finishTimestamp = block.timestamp + _duration;
    }
}