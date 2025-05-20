interface IHasher {
    function hash(bytes memory content) external pure returns (bytes32);
}

contract Anchor {
    bytes32 immutable public contentHash;

    constructor(IHasher hasher, bytes memory content) {
        contentHash = hasher.hash(content);
    }
}

contract Owner is IHasher {
    Anchor public anchor;
    function() internal pure fptr;

    function hash(bytes memory content) external pure returns (bytes32) {
        return keccak256(content);
    }

    function main(bytes memory content) external {
        anchor = new Anchor(this, content);
        fail();
    }

    function fail() internal view {
        // Uninitialized function pointer: should revert
        fptr();
    }
}
