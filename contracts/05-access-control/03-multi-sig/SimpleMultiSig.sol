// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleMultiSig {
    address[] public owners;
    mapping(uint => mapping(address => bool)) public isConfirmed;

    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint numConfirmations;
    }

    Transaction[] public transactions;
    uint public numConfirmationsRequired;

    modifier onlyOwner() {
        bool isOwner = false;
        for (uint i = 0; i < owners.length; i++) {
            if (msg.sender == owners[i]) isOwner = true;
        }
        require(isOwner, "Not owner");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        owners = _owners;
        numConfirmationsRequired = _required;
    }

    // 1. One of the owners submits a transaction
    function submitTransaction(address _to, uint _value) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            executed: false,
            numConfirmations: 0
        }));
    }

    // 2. Other owners provide confirmation (voting)
    function confirmTransaction(uint _txIndex) public onlyOwner {
        require(!isConfirmed[_txIndex][msg.sender], "Already confirmed");

        transactions[_txIndex].numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
    }

    // 3. Execute if sufficient confirmations are received
    function executeTransaction(uint _txIndex) public onlyOwner {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.numConfirmations >= numConfirmationsRequired, "Not enough signers");
        require(!transaction.executed, "Already executed");

        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}("");
        require(success, "Transaction failed");
    }

    receive() external payable {}
}