@external
@pure
def run() -> bytes32:
    return self.calculateHash(b"\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11\0x11")

@internal
@pure
def calculateHash(input: Bytes[4096]) -> bytes32:
    return keccak256(input)
