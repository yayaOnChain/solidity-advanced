// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureEtherStore {

    mapping(address => uint) public balances;

    // SECURE
    function withdraw() public {
        // 1. Checks
        uint bal = balances[msg.sender];
        require(bal > 0);

        // 2. Effects (Update balance to 0 first)
        balances[msg.sender] = 0;

        // 3. Interactions (Send funds)
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send");
    }
}