# Vyper in 10 minutes

## History and overview
- Contract-oriented, pythonic, targets the EVM.
- Originally called Viper, started in 2017 by Vitalik Buterin.
    - Proof-of-concept replacement for an older pythonic language (Serpent).
- Production use: [Curve](https://curve.fi), [Yearn](https://yearn.finance), others.
- Alternative compiler targeting Yul: Rust Vyper.
    - Eventually diverged and turned into [Fe](https://blog.fe-lang.org/posts/fe-a-new-language-for-the-ethereum-ecosystem/), a separate language with a more Rust-like syntax.

----

## What is the language like?
- Imperative.
- Strongly and statically typed.
- High-level.
- Pythonic.
- Small and restrictive, intentionally forgoing features.
- Explicit bounds on everything.

----

## Value types
| Type                     | Vyper                                            | Solidity |
|--------------------------|--------------------------------------------------|----------|
| Boolean                  | `bool`                                           | `bool`
| Integers                 | `int8`, ..., `int256`<br>`uint8`, ..., `uint256` | `int8`, ..., `int256`, `int`<br>`uint8`, ..., `uint256`, `uint`
| Fractional numbers       | `decimal`                                        | `fixed`, `ufixed`
| Fixed bytes              | `bytes1`, ..., `bytes32`                         | `bytes1`, ..., `bytes32`
| Addresses                | `address`                                        | `address`,<br>`address payable`
| Function types           |                                                  | `function () internal`,<br>`function () external`
| Enums                    | `enum`                                           | `enum`
| Contract types           | `interface`                                      | `contract`, `interface`
| User-defined value types |                                                  | `type`

- Pretty similar to Solidity, but some types or aliases are (intentionally) missing.
- Fixed-point types in Solidity were never fully implemented. UDVTs are the replacement.


----

## Reference types
| Type                     | Vyper                       | Solidity                   |
|--------------------------|-----------------------------|----------------------------|
| Static arrays/lists      | `int256[100]`               | `int[100]`                 |
| Dynamic arrays/lists     | `DynArray[int256, 100]`     | `int[]`                    |
| Byte arrays              | `Bytes[100]`                | `bytes`                    |
| Strings                  | `String[100]`               | `string`                   |
| Structs                  | `struct`                    | `struct`                   |
| Mappings                 | `HashMap[address, bool]`    | `mapping(address => bool)` |

- All types in Vyper have bounded size.

----

## Contracts and state variables
<table><tr><td>Vyper</td><td>Solidity</tr><tr><td>

```vyper
# @version ^0.3.0

balances: HashMap[address, int256]
owner: public(address)
LIMIT: constant(int128) = 42

@external
def __init__(newOwner: address):
    self.owner = newOwner
```

</td><td>

```solidity
pragma solidity ^0.8.0;

contract C {
    mapping(address => int) balances;
    address public owner;
    int128 constant LIMIT = 42;

    constructor(uint newOwner) {
        owner = newOwner;
    }
}
```

</td></tr></table>

- One file may contain only one contract.
- No inheritance.
    - But contracts can implement interfaces.
- Only interfaces can be imported.
- No equivalent for Solidity libraries.

----

## Functions
<table><tr><td>Vyper</td><td>Solidity</tr><tr><td>

```vyper
paid: HashMap[address, bool]

@external
@payable
def pay():
    assert msg.value > 0
    self.paid[msg.sender] = True

@external
@nonpayable
def reset(user: address):
    if self.isPaid():
        self.paid[user] = False

@internal
@view
def isPaid() -> bool:
    return self.paid[msg.sender]
```

</td><td>

```solidity
contract C {
    mapping(address => bool) paid;

    function pay() external payable {
        require(msg.value > 0);
        paid[msg.sender] = true;
    }

    function reset(address user) external {
        if (isPaid())
            paid[user] = false;
    }

    function isPaid() internal view
        returns (bool)
    {
        return paid[msg.sender];
    }
}
```

</td></tr></table>

- No `public` and `private` functions (only `internal` and `external`).
- No function overloading.
- No virtual functions.
- No modifiers.
- Recursive calls not allowed.

----

## Events
<table><tr><td>Vyper</td><td>Solidity</tr><tr><td>

```vyper
event Paid:
    sender: indexed(address)
    amount: uint256

@external
@payable
def pay():
    log Paid(
        msg.sender,
        msg.value
    )
```

</td><td>

```solidity
contract C {
    event Paid(
        address indexed sender,
        uint amount
    );

    function pay() external payable {
        emit Paid(
            msg.sender,
            msg.value
        );
    }
}
```

</td></tr></table>

- No anonymous events.

----

## Errors
<table><tr><td>Vyper</td></tr><tr><td>

```vyper
@external
def forward(target: address):
    assert self.balance > as_wei_value(1, "ether"), "No funds."

    send(target, as_wei_value(1, "ether"))
    assert target.balance >= as_wei_value(1, "ether"), UNREACHABLE

    raise "Fail"

    # Only possible in yet unreleased 0.3.8:
    #raw_revert(_abi_encode(13, method_id=method_id("Fail(uint256)")))
```

</td></tr><tr><td>Solidity</td></tr><tr><td>

```solidity
contract C {
    error Fail(uint reason);

    function forward(address payable target) external {
        require(address(this).balance > 1 ether, "No funds.");

        target.transfer(1 ether);
        assert(target.balance >= 1 ether);

        revert Fail(13);
    }
}
```
</td></tr></table>

- No `try`/`catch`.

----

## Loops
<table><tr><td>Vyper</td><td>Solidity</tr><tr><td>

```vyper
for i in range(2, 5):
    # ...
```

```vyper
for i in [2, 3, 4]:
    # ...
```

</td><td>

```solidity
for (uint i = 2; i < 5; ++i)
    // ...
```

</td></tr></table>

Vyper does not support unconstrained iteration:

<table><tr><td>Vyper</td><td>Solidity</tr><tr><td>

*no equivalent*

</td><td>

```solidity
while (condition)
    // ...
```

</td></tr></table>

---

## Default (fallback) function
<table><tr><td>Vyper</td><td>Solidity</tr><tr><td>

```vyper
event Payment:
    value: uint256

@external
@payable
def __default__():
    log Payment(msg.value)
```

</td><td>

```solidity
contract C {
    event Payment(uint value);

    fallback() external payable {
        emit Payment(msg.value);
    }
}
```

</td></tr></table>

- No `receive` function.

---

## Interfaces
<table><tr><td>Vyper</td></tr><tr><td>

```vyper
interface IToken:
    def balanceOf(account: address) -> uint256: view

@external
@view
def getBalance(token: address) -> uint256:
    return IToken(token).balanceOf(self)
```

</td></tr><tr><td>Solidity</td></tr><tr><td>

```solidity
interface IToken {
    function balanceOf(address account) external view returns (uint256);
}

contract C {
    function getBalance(address token) external view returns (uint) {
        return IToken(token).balanceOf(address(this));
    }
}
```

</td></tr></table>

---

## Standard library and built-in utilities
No proper standard library but there are some utilities available out of the box:
- Common interfaces: `IERC20`, `IERC721`, `IERC165`, etc.
- ABI encoding/decoding: `_abi_encode()`, `_abi_decode()`.
- Math functions: `isqrt()`, `min()`, `max()`, `abs()`, etc.
- Integer <-> string conversions.
- Contract creation helpers: `create_minimal_proxy_to()`, `create_copy_of()`, `create_from_blueprint()`.
- Precompiles.
- `print()` (for debugging).

## Miscellaneous
- No inline assembly.
- Supports structured documentation (NatSpec).
- Checked arithmetic by default.
    - Unchecked operations provided via builtins: `unsafe_add()`, `unsafe_sub()`, etc.

## Resources
- Documentation: https://docs.vyperlang.org
- Tutorials: https://learn.vyperlang.org
