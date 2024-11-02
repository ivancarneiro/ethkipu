// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/// @title AuctETH - A smart contract for Ethereum-based auctions
/// @notice This contract allows users to participate in a timed auction
/// @dev Implements features like bid increments, automatic extensions, and refunds with commission
/// @author Ivan Carneiro

contract AuctETH {
    address owner;
    uint256 initValue;
    uint256 currentBid;
    uint8 bidIncrement;
    uint256 duration;
    uint256 finishTimestamp;

    /// @notice Constructor to initialize the auction.
    /// @param _initValue The initial value of the auction item.
    /// @param _bidIncrement The minimum bid increment (in percentage) e.g. 5% > to current bid.
    /// @param _duration The duration of the auction (in seconds), e.g. (5min = 300sec; 10min = 600sec; 1h = 3600sec; 1d = 86400sec).
    constructor(
        uint256 _initValue,
        uint8 _bidIncrement,
        uint256 _duration
    ) {
        owner = msg.sender;
        initValue = _initValue;
        currentBid = 0;
        bidIncrement = _bidIncrement;
        duration = _duration;
        finishTimestamp = block.timestamp + duration;
    }

    // struct Bidder (address)
    struct Bidder {
        uint256 id;
        address addrs;
        uint256 bidValue;
        uint256 bidderBalance;
    }

    // array bidders
    Bidder[] public bidders;

    event NewBid(address indexed addrs, uint256 _bidValue);

    modifier auctionOpened() {
        require(block.timestamp < finishTimestamp, "The auction has ended.");
        _;
    }
    // ofertar
    function makeBid() external auctionOpened {
    }

    // mostrar Ganador
    // mostrar Ofertas
    // devolver Depósitos
    // REEMBOLSO PARCIAL
    // EXTENSION DEL PLAZO
}
