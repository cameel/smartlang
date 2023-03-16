# Flint examples

## Prerequisites
### Docker container to run the examples
```bash
git clone https://github.com/cameel/smartlang/ethporto2023/
cd smartlang/ethporto2023/
docker run -it --rm --volume "$PWD/flint:/code" cameel/flint-archlinux
```

Foundry is no included but can run a long in a second container sharing the `flint/` directory:
```bash
docker run -it --rm --volume "$PWD/flint:/code" cameel/foundry-archlinux
```
### Wallet
We'll get a predictable set of test accounts by always using the same seed:
```bash
export seed="grace crime cat remove spice bean concert lawsuit render horse collect vocal"
export key=0x60b139825a56a987d58b20f0145e05dc45bed12df72cb92812b5ea988383c987
```

## Example 1: Type states and external dispatch
- [`auction.flint`](auction.flint)

Compiling Flint code (in `flint-bionic` container):
```bash
flintc auction.flint --skip-verifier --emit-ir
```

Deploying and interacting with Flint code via Foundry (vyper-archlinuxc` container):
1. Local node on a separate terminal:
    ```bash
    anvil --mnemonic "$seed"
    ```
1. Deploying the compiled bytecode:
    ```bash
    cast send --private-key "$key" --create "$(cat bin/Auction.bin)"
    ```
1. Interacting with the contract
    ```bash
    cast send --private-key "$key" --gas-limit 1000000 <contract address> "bid()"
    ```
1. Debugging
    ```bash
    cast run --debug <transaction id>
    ```

## Example 2: Interfacing with other external contracts
- [`IERC20.flint`](IERC20.flint)
- [`GLDToken.sol`](GLDToken.sol)

1. Install Open Zeppelin
    ```bash
    npm install @openzeppelin/contracts
    ```
1. Build the sample token and distribute balances:
    ```bash
    solc GLDToken.sol --include-path node_modules --base-path . --bin
    cast send --private-key "$key" --gas-limit 10000000 --create <bytecode> "constructor(uint256)" 100
    cast call --private-key "$key" <gld contract address> "balanceOf(address)(uint256)" <holder contract address>
    cast call --private-key "$key" <gld contract address> "balanceOf(address)(uint256)" $(cast wallet address "$key")
    ```

1. Build the holder contract using the token via an external trait:
    ```bash
    flintc IERC20.flint --skip-verifier --emit-ir
    cast send --private-key "$key" --create "$(cat bin/Holder.bin)"
    cast call --private-key "$key" <gld contract address> "balanceOf(address)(uint256)" $(cast wallet address "$key")
    ```

1. Test transfer directly
    ```bash
    cast send --private-key "$key" --gas-limit 1000000 <gld contract address> "transfer(address,uint256)" "<holder contract address>" 50
    cast call --private-key "$key" <gld contract address> "balanceOf(address)(uint256)" <holder contract address>
    cast call --private-key "$key" <gld contract address> "balanceOf(address)(uint256)" $(cast wallet address "$key")
    ```

1. Test transfer via the holder contract
    ```bash
    cast send --private-key "$key" --gas-limit 1000000 <holder contract address "gimmeGold(address)" <gld contract address>
    cast call --private-key "$key" <gld contract address> "balanceOf(address)(uint256)" <holder contract address>
    cast call --private-key "$key" <gld contract address> "balanceOf(address)(uint256)" $(cast wallet address "$key")
    ```
