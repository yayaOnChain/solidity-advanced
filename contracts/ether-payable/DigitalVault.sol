// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DigitalVault {
    address public owner;

    // Event for tracking transactions on the blockchain
    event Deposit(address indexed sender, uint amount);
    event Withdraw(uint amount);

    constructor() {
        owner = msg.sender;
    }

    // 1. 'payable' function so users can send ETH here
    function deposit() public payable {
        require(msg.value > 0, "Amount must be greater than zero");
        emit Deposit(msg.sender, msg.value);
    }

    // 2. Function to check the contract's balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // 3. Withdraw function using 'call' (Modern Standard)
    function withdraw(uint _amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance >= _amount, "Insufficient balance");

        // Sending Ether using .call
        (bool success, ) = owner.call{value: _amount}("");
        require(success, "Failed to send Ether");

        emit Withdraw(_amount);
    }

    // Special function to allow the contract to receive ETH without calling a function (Direct Transfer)
    receive() external payable {}
}