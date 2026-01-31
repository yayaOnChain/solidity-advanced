// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CommunityVault is Ownable {

    constructor() Ownable(msg.sender) {}

    // Sensitive function
    function setTaxRate(uint256 newRate) public onlyOwner {
        // Tax rate change logic
    }

    // Function to renounce ownership already exists in OpenZeppelin library
    // However, we can override it if we want to add additional logic
    function goodbyeAdmin() public onlyOwner {
        renounceOwnership();
    }
}