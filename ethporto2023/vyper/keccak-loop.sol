contract C {
    function run() external pure returns (bytes32) {
        bytes32 hash = 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        for (uint i = 0; i < 10; ++i)
            hash = keccak256(abi.encode(
                0x11111111111111111111111111111111ffffffffffffffffffffffffffffffff,
                hash,
                0x22222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
            ));
        return hash;
    }
}
