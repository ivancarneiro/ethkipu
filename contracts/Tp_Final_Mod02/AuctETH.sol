// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

/// @title AuctETH - A smart contract for Ethereum-based auctions
/// @notice This contract allows users to participate in a timed auction
/// @dev Implements features like bid increments, automatic extensions, and refunds with commission
/// @author Ivan Carneiro

contract AuctETH {
    // Contract variables
    address public owner; // Contract owner's address
    address public winner; // Auction winner's address
    uint256 public initValue; // Initial auction value
    uint256 public highestBid; // Current bid value
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
        highestBid = _initValue;
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

    event ExtendedAuction(uint256 finishTimestamp); // Issued when a new bid is registered within the last ten minutes of the auction ending

    event WithdrawRefund(address indexed bidder, uint256 amount); // Issued when a bidder withdraws the excess of their bid

    event Winner(address indexed winner, uint256 highestBid); // Issued when the owner pays the prize to the winner

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

    /// @notice Returns the highest bid value.
    /// @return uint256.
    function showhighestBid() external view returns (uint256) {
        return highestBid;
    }

    /// @notice Returns the minimum bid increment percentage.
    /// @return uint256.
    function incrementalPercentage() external view returns (uint256) {
        return bidIncrement;
    }

    /// @notice Places a new bid.
    /// @dev Requires bid value to exceed current bid by minimum increment.
    function makeBid() external payable auctionOpened {
        address bidder = msg.sender;
        uint256 bidValue = msg.value;

        require(bidValue >= (highestBid * (bidIncrement + 100) / 100), "The bid must outbid the best bid, considering the minimum increase percentage");

        // Extend auction duration if bid is placed near end
        if (block.timestamp >= finishTimestamp - 600) {
            finishTimestamp += 600;

            emit ExtendedAuction(finishTimestamp);
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
        highestBid = bidValue;

        emit NewBid(bidder, bidValue);
    }

    /// @notice Returns an array of all bids.
    /// @return array.
    function showBids() public view returns (Bid[] memory) {
        Bid[] memory bids = new Bid[](bidderAddresses.length);

        for (uint256 i = 0; i < bidderAddresses.length; i++) {
            bids[i] = Bid(bidderAddresses[i], bidders[bidderAddresses[i]].lastBid);
        }

        return bids;
    }

    /// @notice Allows a bidder to partially refund their balance.
    /// @dev Only the balance owner can call this function.
    function withDraw() external payable {
        // Verify that the message comes from the balance owner
        require(msg.sender == bidders[msg.sender].addrs, "Only the balance owner can initiate the refund");

        // Verify that the bidder has made more than one bid
        require(bidders[msg.sender].balance > bidders[msg.sender].lastBid, "No refund will be allowed if you have not placed a bid after the last offer");

        // Calculate the available refund amount
        uint256 refundAmount = bidders[msg.sender].balance - bidders[msg.sender].lastBid;

        // Check if there is a balance available for refund
        require(refundAmount > 0, "No balance available for refund");

        // Update the bidder's balance
        bidders[msg.sender].balance -= refundAmount;

        // Transfer the refund amount to the bidder
        (bool success, ) = payable(msg.sender).call{value: refundAmount}("");

        // Verify if the call was successful
        require(success, "Error processing the refund");

        emit WithdrawRefund(msg.sender, refundAmount);
    }

    /// @notice Returns bids and refunds deposits to non-winning bidders, transfers the winning bid to the winner.
    /// @dev Only the auction owner can call this function.
    function returnsBids() public payable onlyOwner {
        // Verify that the auction has ended
        require(block.timestamp >= finishTimestamp, "The auction must end");

        // Get the number of bidder addresses
        uint256 len = bidderAddresses.length;

        // Iterate through each bidder address
        for (uint256 i = 0; i < len; i++) {
            // Check if the bidder is not the winner
            if (bidders[bidderAddresses[i]].addrs != winner) {

                // Calculate the deposit amount to refund (lastBid - 2% for gas)
                uint256 depositAmount = (bidders[bidderAddresses[i]].lastBid * (100 - 2) / 100);

                // Transfer the deposit amount to the bidder
                (bool success, ) = payable(bidderAddresses[i]).call{value: depositAmount}("");
                
                // Verify if the call was successful
                require(success, "Error processing the deposit refund");
                
                // Reset the bidder's last bid and balance to zero
                bidders[bidderAddresses[i]].lastBid = 0;
                bidders[bidderAddresses[i]].balance = 0;

            } else {
                // Transfer the winning bid amount to the winner
                (bool success, ) = payable(winner).call{value: highestBid}("");
                
                // Verify if the call was successful
                require(success, "Failed to transfer prize to winner");
                
                // Reset the winner's last bid and balance to zero
                bidders[winner].lastBid = 0;
                bidders[winner].balance = 0;
            }
        }

        // Emit the Winner event with the winner's address and winning bid
        emit Winner(winner, highestBid);
    }

    /// @notice Returns the winner's address and winning bid.
    /// @dev This function can be called after the auction has ended.
    /// @return winnerAddress The winner's Ethereum address.
    /// @return winningBid The winning bid amount.
    function getWinner() external view auctionFinished returns (address winnerAddress, uint256 winningBid) {
        // Return the winner's address and winning bid
        return (winner, highestBid);
    }
}