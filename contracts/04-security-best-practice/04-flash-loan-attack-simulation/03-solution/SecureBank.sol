// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import Chainlink interface
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract SecureBank {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Ethereum Mainnet
     * Aggregator: ETH/USD
     * Address: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
     */
    constructor() {
        // Chainlink aggregator contract address (different on each network)
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }

    /**
     * Gets the latest price from Chainlink
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        // SECURITY VALIDATION:
        // Ensuring data is not stale
        require(timeStamp > 0, "Round incomplete");
        require(block.timestamp - timeStamp < 3600, "Data too old/stale");

        return price;
    }

    function borrow(uint256 ethAmount) public {
        int price = getLatestPrice();
        // Now the price comes from an external aggregated source,
        // Not from a DEX pool that can be manipulated with Flash Loans.

        // Continue with safe borrowing logic...
    }
}