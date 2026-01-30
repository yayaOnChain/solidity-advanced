// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// DO NOT COPY - Vulnerable to Oracle Manipulation
interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract VulnerableBank {
    IUniswapV2Pair public pool; // ETH/DAI Pool

    constructor(address _pool) {
        pool = IUniswapV2Pair(_pool);
    }

    // Function to calculate how much DAI can be borrowed based on ETH collateral
    function getPrice() public view returns (uint256) {
        (uint112 reserve0, uint112 reserve1, ) = pool.getReserves();
        // HIGHLY DANGEROUS: Price is determined directly from current pool reserves
        return uint256(reserve1) / uint256(reserve0);
    }

    function borrow(uint256 ethAmount) public {
        uint256 price = getPrice();
        // Borrowing logic...
    }
}