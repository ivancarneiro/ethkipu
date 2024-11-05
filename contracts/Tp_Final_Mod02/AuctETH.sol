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
    uint256 bidIncrement = 2;
    uint256 duration;
    uint256 finishTimestamp;

    /// @notice Constructor to initialize the auction.
    /// @param _initValue The initial value of the auction item.
    /// @param _bidIncrement The minimum bid increment (in percentage), if not specified, will be 2%.
    /// @param _duration The duration of the auction (in seconds), e.g. (5min = 300sec; 10min = 600sec; 1h = 3600sec; 1d = 86400sec).
    constructor(uint256 _initValue, uint256 _bidIncrement, uint256 _duration) {
        require(_initValue > 0,"The initial value must be greater than zero for the gas");
        owner = msg.sender;
        initValue = _initValue;
        currentBid = _initValue;
        bidIncrement = _bidIncrement;
        duration = _duration;
        finishTimestamp = block.timestamp + duration;
    }

    mapping(address => uint256) public offers;

    // struct Bidder (address)
    struct Bidder {
        address addrs;
        uint256 lastBid;
    }

    Bidder[] public bidders; // array de todos los pujadores

    address[] public uniqueAddr; // array de direcciones unicas


    event NewBid(address indexed _bidder, uint256 _bidValue);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner,"Only the auction owner can execute this function");
        _;
    }

    modifier auctionOpened() {
        require(block.timestamp < finishTimestamp, "The auction has ended");
        _;
    }

    modifier auctionFinished() {
        require(block.timestamp >= finishTimestamp,"The auction has not yet ended");
        _;
    }


    // mostrar oferta actual
    function showCurrentBid() external view returns (uint256 _currentBid) {
        _currentBid = currentBid;
        return (_currentBid);
    }

    // ofertar
    function makeBid() external payable auctionOpened {
        address _bidder = msg.sender;
        uint256 _bidValue = msg.value;

        require(_bidValue > (currentBid * ((bidIncrement + 100) / 100)),"The bid must exceed the best offer, taking into account the minimum incremental value");
        if (offers[_bidder]==0) {
            uniqueAddr.push(_bidder);
        }
        offers[_bidder] += _bidValue;
        currentBid = _bidValue;
        bidders.push(Bidder(_bidder, _bidValue));
        emit NewBid(_bidder, _bidValue);
    }

    // mostrar ofertas
    function showBidders() external view returns (Bidder[] memory _bidders) {
        uint256 len = uniqueAddr.length;
        for (uint256 i=0; i<len; i++){
            _bidders[i] = Bidder( uniqueAddr[i],offers[uniqueAddr[i]]);
        }
    }

    // REEMBOLSO PARCIAL
    // EXTENSION DEL PLAZO

    // devolver Depósitos
    function returnDeposits() public payable onlyOwner {
        // ejecuta un revert si la subasta no ha finalizado.
        if (block.timestamp < finishTimestamp) {
            revert("The auction has not ended");
        }
    }

    // mostrar Ganador
    function showWinner() external auctionFinished {}
}
