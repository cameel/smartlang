contract C {
    function run(
        uint256 v01, uint v02, uint v03, uint v04,
        uint256 v05, uint v06, uint v07, uint v08,
        uint256 v09, uint v10, uint v11, uint v12,
        uint256 v13, uint v14, uint v15, uint v16,
        uint256 v17, uint v18
    ) public pure returns (uint out) {

        assembly ("memory-safe") {
            function f(
                x01, x02, x03, x04,
                x05, x06, x07, x08,
                x09, x10, x11, x12,
                x13, x14, x15, x16,
                x17, x18
            ) -> mask {
                mask := x01
                mask := xor(mask, x02)
                mask := xor(mask, x03)
                mask := xor(mask, x04)
                mask := xor(mask, x05)
                mask := xor(mask, x06)
                mask := xor(mask, x07)
                mask := xor(mask, x08)
                mask := xor(mask, x09)
                mask := xor(mask, x10)
                mask := xor(mask, x11)
                mask := xor(mask, x12)
                mask := xor(mask, x13)
                mask := xor(mask, x14)
                mask := xor(mask, x15)
                mask := xor(mask, x16)
                mask := xor(mask, x17)
                mask := xor(mask, x18)
            }

            out := f(
                mul(add(v01, v01), add(v01, v01)),
                mul(add(v02, v02), add(v02, v02)),
                mul(add(v03, v03), add(v03, v03)),
                mul(add(v04, v04), add(v04, v04)),
                mul(add(v05, v05), add(v05, v05)),
                mul(add(v06, v06), add(v06, v06)),
                mul(add(v07, v07), add(v07, v07)),
                mul(add(v08, v08), add(v08, v08)),
                mul(add(v09, v09), add(v09, v09)),
                mul(add(v10, v10), add(v10, v10)),
                mul(add(v11, v11), add(v11, v11)),
                mul(add(v12, v12), add(v12, v12)),
                mul(add(v13, v13), add(v13, v13)),
                mul(add(v14, v14), add(v14, v14)),
                mul(add(v15, v15), add(v15, v15)),
                mul(add(v16, v16), add(v16, v16)),
                mul(add(v17, v17), add(v17, v17)),
                mul(add(v18, v18), add(v18, v18))
            )
        }
        return out;
    }
}
