// MODERN PRAGMA (SECURE)
pragma solidity 0.8.20;

contract SecureToken {
    mapping(address => uint256) public balances;

    function transfer(address _to, uint256 _value) public {
        // If balances[msg.sender] is less than _value,
        // the transaction will automatically REVERT at this line without needing manual check.
        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }
}