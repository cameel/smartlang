contract Checked {
    function checked(int a, int b) external returns (int, int, int, int) {
        return (
            a + b,
            a - b,
            a * b,
            a / b
        );
    }
}

contract Unchecked {
    function checked(int a, int b) external returns (int, int, int, int) {
        unchecked {
            return (
                a + b,
                a - b,
                a * b,
                a / b
            );
        }
    }
}
