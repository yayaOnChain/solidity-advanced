// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlashLoanAttacker {
    function startAttack(uint256 amountToBorrow) external {
        // 1. Call Flash Loan (e.g. from Aave or Uniswap)
        // flashLoan(address(this), amountToBorrow);
    }

    // Callback function called after receiving the loan
    function executeOperation(uint256 loanAmount) external {
        // 2. DUMP: Sell the borrowed ETH massively to the ETH/DAI Pool.
        // Result: ETH reserves in the pool become very high, causing ETH price to plummet drastically.

        // 3. EXPLOITATION: Since ETH price at VulnerableBank is now very cheap (due to manipulation),
        // the attacker borrows large amounts of DAI with very little ETH collateral.

        // 4. BUY BACK: Buy back the previously sold ETH to normalize positions.

        // 5. REPAY LOAN: Return loanAmount + fee to the Flash Loan provider.
        // Remaining profit goes to the attacker's pocket.
    }
}