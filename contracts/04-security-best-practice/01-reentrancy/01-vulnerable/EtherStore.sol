// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherStore {

    mapping(address => uint) public balances;

    // DO NOT COPY - Vulnerable to Reentrancy
    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);

        (bool sent, ) = msg.sender.call{value: bal}(""); // External interaction
        require(sent, "Failed to send");

        balances[msg.sender] = 0; // State update performed LAST
    }
}