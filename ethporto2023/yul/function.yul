object "C" {
    code {
        sstore(0, plus(1, 2))

        function plus(x, y) -> z {
            z := add(x, y)
        }
    }
}
