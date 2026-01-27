// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureAuction {
    address public highestBidder;
    uint public highestBid;

    // Mapping to store withdrawable balances
    mapping(address => uint) public pendingReturns;

    // DO NOT COPY: Vulnerable to Denial of Service
    /*
    function bid() public payable {
        require(msg.value > highestBid, "Bid too low");

        // Push: Automatically sending money to the previous bidder
        // If highestBidder is a malicious contract that rejects transfers,
        // then no one else can ever bid again!
        payable(highestBidder).transfer(highestBid);

        highestBidder = msg.sender;
        highestBid = msg.value;
    }
    */

    function bid() public payable {
        require(msg.value > highestBid, "Bid too low");

        if (highestBid != 0) {
            // Instead of sending directly, we store it in the mapping
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    // Special function for users to withdraw their own funds
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // Important: Zero out the balance BEFORE sending to prevent Reentrancy
            pendingReturns[msg.sender] = 0;

            (bool success, ) = msg.sender.call{value: amount}("");
            if (!success) {
                // If failed, restore the balance
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
}