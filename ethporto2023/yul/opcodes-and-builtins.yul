object "C" {
    code {
        datacopy(0, dataoffset("C_deployed"), datasize("C_deployed"))
        return(0, datasize("C_deployed"))
    }

    object "C_deployed" {
        code {
            mstore(mul(0x20, 4), origin())
            sstore(0x100, and(0xff, sload(0x100)))
        }
    }
}
