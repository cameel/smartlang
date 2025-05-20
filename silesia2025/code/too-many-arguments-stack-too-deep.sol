contract C {
    function f(
        uint, uint, uint, uint,
        uint, uint, uint, uint,
        uint, uint, uint, uint,
        uint, uint, uint, uint, uint
    ) internal
    {}

    function run() external {
        f(
             1,  2,  3,  4,
             5,  6,  7,  8,
             9, 10, 11, 12,
            13, 14, 15, 16, 17
        ); // Error: Stack too deep.
    }
}
