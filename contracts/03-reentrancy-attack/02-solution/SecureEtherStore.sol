// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev Using the OpenZeppelin library is the safest way to prevent Reentrancy.
 * This library provides the 'nonReentrant' modifier.
 */
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SecureEtherStore is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /**
     * @notice Safe withdraw function with two layers of protection:
     * 1. Checks-Effects-Interactions (CEI) pattern
     * 2. ReentrancyGuard (nonReentrant modifier)
     */
    function withdraw() public nonReentrant {
        // --- 1. CHECKS ---
        uint256 bal = balances[msg.sender];
        require(bal > 0, "Insufficient balance");

        // --- 2. EFFECTS ---
        // We decrease the USER'S balance BEFORE sending money.
        // If the attacker tries to call withdraw() again via fallback,
        // their balance is already 0 and will fail at the 'Checks' stage.
        balances[msg.sender] = 0;

        // --- 3. INTERACTIONS ---
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
    }

    // Helper function to check the contract's balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}