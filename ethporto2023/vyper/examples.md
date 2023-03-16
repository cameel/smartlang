# Vyper examples

## Prerequisites
### Docker container to run the examples
```bash
git clone https://github.com/cameel/smartlang/ethporto2023/
cd smartlang/ethporto2023/
docker run -it --rm --volume "$PWD/vyper:/code" cameel/vyper-archlinux
```

The `vyper/` subdirectory will be shared with the container as `/code/`.
This is the directory we'll be working in.

### Wallet
We'll get a predictable set of test accounts by always using the same seed:
```bash
export seed="grace crime cat remove spice bean concert lawsuit render horse collect vocal"
export key=0x60b139825a56a987d58b20f0145e05dc45bed12df72cb92812b5ea988383c987
```

## Example 1: Keccak loop

- [`keccak-loop.sol`](keccak-loop.sol)
- [`keccak-loop.vy`](keccak-loop.vy)

### Solidity

Executing the `run()` function with `forge debug`:
```bash
forge debug keccak-loop.sol --use "$(command -v solc)"
```
- Compiles the example and lanuches the debugger.
- `--use "$(command -v solc)"` tells `forge` to use system-wide `solc`.
    Otherwise it would ignore it and download the latest binary on its own.

### Vyper

Manually deploying the contract and executing the `run()` function:
1. (in a separate terminal) Start a local node for testing
     ```bash
    anvil --mnemonic "$seed"
    ```
1. Compile the Vyper contract to bytecode:
    ```bash
    cd /code/
    vyper keccak-loop.vy
    ```

1.  Deploy the bytecode:
    ```bash
    cast send --private-key "$key" --create <bytecode>
    ```

1. Send a transaction to call the `run()` function:
    ```bash
    cast send --private-key "$key" --gas-limit 1000000 <contract address> "run()"
    ```

1. Debug the transaction:
    ```bash
    cast run --debug <transaction id>
    ```

#### Helper for manual debugging
Typing it all every time is annoying.
We can easily automate the whole process with a bit of JSON glue:

```bash
function debug_bytecode {
    local bytecode="$1"
    local sig="$2"

    contract_address=$(
        cast send \
            --json \
            --private-key "$key" \
            --create "$bytecode" |
        jq --raw-output .contractAddress
    )

    transaction_id=$(
        cast send \
            --json \
            --private-key "$key" \
            --gas-limit 1000000 \
            "$contract_address" \
            "$sig" |
        jq --raw-output .transactionHash
    )

    cast run --debug "$transaction_id"
}
```
Use for Vyper:
```bash
bytecode=$(vyper keccak-loop.vy)
debug_bytecode ${bytecode} "run()"
```
Use for Solidity:
```bash
bytecode=$(solc keccak-loop.sol --combined-json bin | jq '.contracts."keccak-loop.sol:C".bin')
debug_bytecode ${bytecode} "run()"
```

## Example 2: Dynamic array

- [`dynamic-array.sol`](dynamic-array.sol)
- [`dynamic-array.vy`](dynamic-array.vy)

Compile and inspect in debugger the same way as in the previous example.

- Static memory allocation may also waste memory.
