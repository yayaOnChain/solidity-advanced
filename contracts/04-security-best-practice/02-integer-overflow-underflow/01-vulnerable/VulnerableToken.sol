// OLD PRAGMA (VULNERABLE TO BUGS)
pragma solidity 0.7.0;

contract VulnerableToken {
    mapping(address => uint256) public balances;

    function transfer(address _to, uint256 _value) public {
        // If my balance is 0, and I send 1 token
        // 0 - 1 = 115792089237316195423570985008687907853269984665640564039457584007913129639935 (Underflow)
        // This check will pass (bypass) because the number above is extremely large!
        require(balances[msg.sender] - _value >= 0);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }
}