object "C" {
    code {}

    object "Var" {
        code {
            let x := sload(1)
            sstore(0, x)
        }
    }

    object "NoBar" {
        code {
            sstore(0, sload(1))
        }
    }
}
