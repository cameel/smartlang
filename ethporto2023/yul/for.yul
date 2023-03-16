object "C" {
    code {
        for { let i := 0 } lt(i, 5) { i := add(i, 1) } {
            sstore(0, 0)
        }
    }
}
