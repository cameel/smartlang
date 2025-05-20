contract C  {
    function(uint) internal fptr = c;

    function a(uint x) internal pure {
        assert(x == 42);
    }
    function b(uint x) internal pure {
        require(x == 66);
        assert(x == 66);
    }
    function c(uint x) internal pure {
        require(x == 66);
        assert(x == 42);
    }

    function main(uint x) external {
        fptr(x);
    }
}
