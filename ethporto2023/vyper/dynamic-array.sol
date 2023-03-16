contract C {
    function run() external pure returns (bytes32) {
        return calculateHash(hex"11111111111111111111111111111111");
    }

    function calculateHash(bytes memory input) internal pure returns (bytes32) {
        return keccak256(input);
    }
}
