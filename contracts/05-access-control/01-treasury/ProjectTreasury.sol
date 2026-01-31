// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract ProjectTreasury is AccessControl, Pausable {
    // 1. Define Roles using hashing
    bytes32 public constant TREASURER_ROLE = keccak256("TREASURER_ROLE");
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor(address admin, address treasurer, address manager) {
        // 2. Set up role hierarchy
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(TREASURER_ROLE, treasurer);
        _grantRole(MANAGER_ROLE, manager);
    }

    // Function can only be called by Treasurer
    function withdrawFunds(address payable to, uint256 amount) public onlyRole(TREASURER_ROLE) {
        require(address(this).balance >= amount, "Insufficient balance");
        to.transfer(amount);
    }

    // Emergency function: can only be called by Manager
    function emergencyPause() public onlyRole(MANAGER_ROLE) {
        _pause();
    }

    function resume() public onlyRole(MANAGER_ROLE) {
        _unpause();
    }

    // Function to receive funds
    receive() external payable {}
}