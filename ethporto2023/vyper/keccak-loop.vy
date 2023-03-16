@external
def run() -> bytes32:
    hash: bytes32 = 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    for i in range(10):
        hash = keccak256(_abi_encode(
            0x11111111111111111111111111111111ffffffffffffffffffffffffffffffff,
            hash,
            0x22222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
        ))
    return hash
