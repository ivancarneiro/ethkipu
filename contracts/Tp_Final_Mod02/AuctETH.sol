// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Strings.sol";

/// @title AuctETH - A smart contract for Ethereum-based auctions
/// @notice This contract allows users to participate in a timed auction
/// @dev Implements features like bid increments, automatic extensions, and refunds with commission
/// @author Ivan Carneiro

contract AuctETH {
    // Contract variables
    address public owner; // Contract owner's address
    address public winner; // Auction winner's address
    uint256 public initValue; // Initial auction value
    uint256 public currentBid; // Current bid value
    uint256 public bidIncrement; // Minimum bid increment (percentage)
    uint256 public duration; // Auction duration (seconds)
    uint256 public finishTimestamp; // Auction end timestamp

    /// @notice Constructor to initialize the auction.
    /// @param _initValue The initial value of the auction item.
    /// @param _bidIncrement The minimum bid increment (in percentage).
    /// @param _duration The duration of the auction (in seconds).
    constructor(uint256 _initValue, uint256 _bidIncrement, uint256 _duration) {
        require(_initValue > 0, "The initial value must be greater than zero for gas");
        owner = msg.sender;
        initValue = _initValue;
        currentBid = _initValue;
        bidIncrement = _bidIncrement;
        duration = _duration;
        finishTimestamp = block.timestamp + duration;
    }

    // Data structures
    struct Bidder {
        address addrs; // Bidder's Ethereum address
        uint256 lastBid; // Bidder's last bid value
        uint256 balance; // Bidder's balance
    }

    struct Bid {
        address bidder; // Bidder's Ethereum address
        uint256 amount; // Bid value
    }

    // Mappings and arrays
    mapping(address => Bidder) public bidders; // Mapping of bidders by address
    address[] public bidderAddresses; // Array of bidder addresses

    // Events
    event NewBid(address indexed bidder, uint256 bidValue); // Emitted when a new bid is placed

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the auction owner can execute this function");
        _;
    }

    modifier auctionOpened() {
        require(block.timestamp < finishTimestamp, "The auction has ended");
        _;
    }

    modifier auctionFinished() {
        require(block.timestamp >= finishTimestamp, "The auction has not yet ended");
        _;
    }

    /// @notice Returns the current bid value.
    /// @return The current bid value.
    function showCurrentBid() external view returns (uint256) {
        return currentBid;
    }

    /// @notice Returns the minimum bid increment percentage.
    /// @return The minimum bid increment percentage.
    function incrementalPercentage() external view returns (uint256) {
        return bidIncrement;
    }

    /// @notice Places a new bid.
    /// @dev Requires bid value to exceed current bid by minimum increment.
    function makeBid() external payable auctionOpened {
        address bidder = msg.sender;
        uint256 bidValue = msg.value;

        require(bidValue > (currentBid * (bidIncrement + 100) / 100), "The bid must outbid the best bid, considering the minimum increase percentage");

        // Extend auction duration if bid is placed near end
        if (block.timestamp >= finishTimestamp - 600) {
            finishTimestamp += 600;
        }

        // Update bidder's information
        if (bidders[bidder].addrs != address(0)) {
            bidders[bidder].lastBid = bidValue;
            bidders[bidder].balance += bidValue;
        } else {
            bidderAddresses.push(bidder);
            bidders[bidder] = Bidder(bidder, bidValue, bidValue);
        }

        winner = bidder;
        currentBid = bidValue;

        emit NewBid(bidder, bidValue);
    }

    /// @notice Returns an array of all bids.
    /// @return An array of Bid structs.
    function showBids() public view returns (Bid[] memory) {
        Bid[] memory bids = new Bid[](bidderAddresses.length);

        for (uint256 i = 0; i < bidderAddresses.length; i++) {
            bids[i] = Bid(bidderAddresses[i], bidders[bidderAddresses[i]].lastBid);
        }

        return bids;
    }

    /// @notice Alternative function to show offers and bids on JSON format
    /// @notice Returns a JSON string of all bids.
    /// @return A JSON string.
    function getBids() public view returns (string memory) {
        // Initializes the result string
        string memory result = "[";
 
        // Iterates over bidder addresses
        for (uint256 i = 0; i < bidderAddresses.length; i++) {
            // Constructs the JSON object for each bid
            result = string(abi.encodePacked(result, "{\"bidder\":\"", Strings.toHexString(bidderAddresses[i]), "\",\"amount\":\"", Strings.toString(bidders[bidderAddresses[i]].lastBid), "\"}"));

            // Appends comma if not the last element
            if (i < bidderAddresses.length - 1) {
                result = string(abi.encodePacked(result, ","));
            }
        }

        // Closes the JSON string
        result = string(abi.encodePacked(result, "]"));

        // Returns the JSON string
        return result;
        }

}