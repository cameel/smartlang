# Yul examples

## Prerequisites
### Docker container to run the examples
The Solidity compiler is included in the `cameel/vyper-archlinux` image.
```bash
git clone https://github.com/cameel/smartlang/ethporto2023/
cd smartlang/ethporto2023/
docker run -it --rm --volume "$PWD/yul:/code" cameel/vyper-archlinux
```
The `yul/` subdirectory will be shared with the container as `/code/`.
This is the directory we'll be working in.

### Wallet
We'll get a predictable set of test accounts by always using the same seed:
```bash
export seed="grace crime cat remove spice bean concert lawsuit render horse collect vocal"
export key=0x60b139825a56a987d58b20f0145e05dc45bed12df72cb92812b5ea988383c987
```

## Example 1: Low overhead compared to EVM assembly

- [`opcodes-and-builtins.yul`](opcodes-and-builtins.yul)
- [`variable.yul`](variable.yul)
- [`if.yul`](if.yul)
- [`for.yul`](for.yul)
- [`function.yul`](function.yul)

When using opcodes and builtins without control structures there is zero overhead:
```bash
solc --debug-info none --strict-assembly opcodes-and-builtins.yul --asm
```
- Note: Do not confuse `--strict-assembly` with `--yul`.
    The `--yul` option is for the obsolete typed dialect of Yul.

Note that `--asm` output is not completely raw.
For exaple some builtins are still presented in Yul-like syntax.
Use Foundry debugger to see the opcodes they translate to:
```bash
anvil --mnemonic "$seed"
```
```bash
solc --debug-info none --strict-assembly opcodes-and-builtins.yul --bin
cast send --private-key "$key" --create <bytecode>
cast run --debug <creation transaction id>
```

Conditionals and loops are just jumps with extra management of the condition/counter:
```bash
solc --debug-info none --strict-assembly ir.yul --asm
solc --debug-info none --strict-assembly for.yul --asm
```

Functions pass arguments and return values through stack:
```bash
solc --debug-info none --strict-assembly function.yul --asm
```

## Example 2: Lack of high-level Solidity features
- [`external-function.sol`](external-function.sol)
- [`abi-and-memory.sol`](abi-and-memory.sol)
- [`checked-arithmetic.sol`](checked-arithmetic.sol)

External functions are simulated via *external dispatch*:
```bash
solc --debug-info none external-function.sol --ir-optimized --optimize
```

ABI encoding/decoding and free memory pointer management is extra code generated on demand by the Solidity compiler.
```bash
solc --debug-info none abi-and-memory.sol --ir-optimized --optimize
```

Checked arithmetic just inserts extra conditionals.
Without them arithmetic operators translate almost directly to the equivalent Yul opcodes:
```bash
solc --debug-info none checked-arithmetic.sol --ir-optimized --optimize
```
