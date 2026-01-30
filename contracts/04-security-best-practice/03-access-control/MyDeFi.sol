pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MyDeFi is Ownable {
    // Only the owner can call this thanks to the 'onlyOwner' modifier
    function emergencyWithdraw() public onlyOwner {
        // ... withdrawal logic
    }
}