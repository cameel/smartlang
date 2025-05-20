contract C {
    uint[] x;

    function g() internal {
        for (uint i = 0; i < 10; ++i) {
            x.push();
            if (i % 5 == 0)
                break;
        }
    }

    function f() external {
        g();
    }
}
