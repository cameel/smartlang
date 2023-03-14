# Yul in 5 minutes

## History and overview
- Intermediate representation (IR) designed for the Solidity compiler.
    Adaptable to other targets, like Ewasm.
- Originally called JULIA (Joyfully Universal Language for (Inline) Assembly), first introduced in 2017 by the Solidity team.
- Currently in use by the Solidity and Fe compilers. Historically also by others (e.g. Flint).
- Also used as the inline assembly in Solidity.
- `solc` is currently in the process of switching to generating Yul code by default.
- Base for [Yul+](https://yulp.fuel.sh), an experimental extension meant to make it more usable to humans rather than machines (currently abandoned).

----

## What is the language like?
- Imperative.
- Untyped.
- Low-level.
- Curly-braced.
- Very simple, with few features.
- Designed to be easy to generate automatically but still readable.

----

## Statements
### Variable declaration
```yul
let x := 42
```

### Variable assignment
```yul
x := 42
```

### Expression
```yul
add(x, mul(y, z))
iszero(y)
```

### Block
```yul
{
    x := 42
}
```

### Condition
```yul
if iszero(y) {
    x := 42
}
```
- There is no `else` in Yul.

### Loop
```yul
for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
    x := 42
}
```

### Switch
```yul
switch y
case 0 {
    x := 1
}
case 1 {
    x := 2
}
default {
    x := 3
}
```

### Function definition
```yul
function f(x, y, z) -> a, b, c {
    a := x
    b := y
    c := z
}

function g(x, y, z) -> a, b, c {
    a, b, c := f(x, y, z)
}
```

## Literals
```yul
let a := 1
let b := 0x01
let c := true
let d := "1"
let e := hex"01"
```

## Opcodes

| Calculation    | Data access        | Environment     | Calls/logs       | Control flow     |
|----------------|--------------------|-----------------|------------------|------------------|
| `add()`        | `mload()`          | `chainid()`     | `call()`         | `return()`       |
| `sub()`        | `mstore()`         | `address()`     | `callcode()`     | `stop()`         |
| `mul()`        | `mstore8()`        | `balance()`     | `delegatecall()` | `revert()`       |
| `div()`        | `sload()`          | `selfbalance()` | `staticcall()`   | `selfdestruct()` |
| `sdiv()`       | `sstore()`         | `caller()`      | `create()`       | `invalid()`      |
| `mod()`        |                    | `callvalue()`   | `create2()`      |                  |
| `smod()`       | `calldataload()`   | `basefee()`     |                  | `pop()`          |
| `exp()`        | `calldatasize()`   | `origin()`      | `log0()`         |                  |
| `not()`        | `calldatacopy()`   | `gasprice()`    | `log1()`         |                  |
| `lt()`         | `codesize()`       | `gaslimit()`    | `log2()`         |                  |
| `gt()`         | `codecopy()`       | `blockhash()`   | `log3()`         |                  |
| `slt()`        | `extcodesize()`    | `coinbase()`    | `log4()`         |                  |
| `sgt()`        | `extcodecopy()`    | `timestamp()`   |                  |                  |
| `eq()`         | `extcodehash()`    | `number()`      |                  |                  |
| `iszero()`     | `returndatasize()` | `difficulty()`  |                  |                  |
| `and()`        |  returndatacopy()` | `prevrandao()`  |                  |                  |
| `or()`         |                    |                 |                  |                  |
| `xor()`        |                    | `gas()`         |                  |                  |
| `shl()`        |                    | `pc()`          |                  |                  |
| `shr()`        |                    | `msize()`       |                  |                  |
| `sar()`        |                    |                 |                  |                  |
| `byte()`       |                    |                 |                  |                  |
| `addmod()`     |                    |                 |                  |                  |
| `mulmod()`     |                    |                 |                  |                  |
| `signextend()` |                    |                 |                  |                  |
| `keccak256()`  |                    |                 |                  |                  |

## Built-ins
- `datasize(x)`, `dataoffset(x)` and `datacopy(t, f, l)`
- `setimmutable(offset, "name", value)` and `loadimmutable("name")`
- `linkersymbol("library_id")`
- `memoryguard(size)`
- `verbatim_1i_1o(hex"600202", x)`

## Objects
```yul
object "C" {
    code {
        let size := datasize("C")
        datacopy(0, dataoffset("C_deployed"), size)
        return(0, size)
    }

    data "Tag" hex"4123"

    object "C_deployed" {
        code {
            mstore(0x40, 0x80)
        }

        object "B" {
            code {
                let o := dataoffset("other")
                sstore(0, o)
            }
            data ".metadata" "M1"
            data "other" "Hello, World2!"
        }

        data "C" "ABC"
        data ".metadata" "M2"
        data "x" "Hello, World2!"
    }
}
```

## Unavailable high-level features
- Types.
- Operators.
- Checked arithmetic.
- External functions.
- ABI encoding/decoding.
- Imports.
- Constants and immutables.
- Memory management.


## Resources
- Documentation: https://docs.soliditylang.org/en/latest/yul.html
