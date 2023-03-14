# Flint in 10 minutes

## History and overview
- Experimental contract-oriented programming language aiming to address design flaws that enabled some of the attacks on early Ethereum smart contracts.
- Targeting both EVM and Libra.
    Compiles to Solidity and Move.
- Actively developed between 2018 and 2019 at Imperial College Department of Computing.
- Its successor language targeting Ewasm instead of Solidity IR was [Flint 2](https://github.com/flintlang/flint-2/).
    Developed during the summer 2020. Development has since stopped.

----

## What is the language like?
- Imperative.
- Strongly and statically typed.
- High-level.
- Curly-braced.
- Syntax inspired by Swift and Solidity.

----

## Native types
- `Int`
- `Address`
- `Bool`
- `String`
- Dynamic-size list: `[Int]`
- Fixed-size list: `Int[100]`
- Dictionary: `[Address: Bool]`
- Contract instances
- Structs
    ```flint
    struct Rectangle {
        var width: Int = 0
        var height: Int = 0
    }
    ```
- Enumerations
    ```flint
    enum Direction: Int {
        case Left
        case Right = 1
    }
    ```

---

## External types
ABI-compatible types for use in external interfaces:
- `int8`, ... `int256`, `uint8`, ... `uint256`
- `address`
- `string`
- `bool`
- `bytes32`

---

## Loops
Half-open ranges:
```flint
for let item: Int in (0..<5) {}
```

Open ranges:
```flint
for let item: Int in (0...5) {}
```

Lists:
```flint
var list: [Int]
for let item: Int in list {}
```

Dictionaries:
```flint
var dict: [Address: Int]
for let item: Int in dict {}
```
- `item` iterates over values, not keys!

---

### Contracts and state variables
```flint
contract C {
    var balances: [Address: Int] = [:]
    public var owner: Address
    visible var balance: Wei = Wei(0)
    let LIMIT: Int = 42
}

C :: (any) {
    public init(newOwner: Address) {
        owner = newOwner
    }
}
```
- There is no inheritance.
    - But contracts can implement traits, which can provide already implemented functions.
- Every contract must have an initializer (equivalent of constructor in Solidity).
- Initializers can be overloaded.
- Functions are defined inside *protection blocks*.

---

## Functions
```flint
func add(a: Int, b: Int = 1) -> Int {
    return a + b
}
```
- Arguments can have default values.
- No tuples. Only a single value can be returned.
- Overloading is not allowed for contract functions.

---

## Function visibility

```flint
func f() {}
public func g() {}
```
- Functions are private by default (but there's no `private` keyword).
- Public and private functions correspond to external and internal ones in Solidity.

---

## Type states
```flint
contract Door (Closed, Open) {}

Door @(Closed) :: (any) {
    public init() {
        become Closed
    }

    public func open() {
        become Open
    }
}

Door @(Open) :: (any) {
    public func close() {
        become Closed
    }
}
```
- Contracts can have states.
- Switching between states is done with `become`.
- Only functions from the current state are available.
- There is an (unimplemented) idea to use states to prevent reentrancy.

---

### Caller groups
```flint
contract Vault {
    let owner: Address
    var managers: [Address] = []
}

Vault :: caller <- (any) {
    public init() {
        owner = caller
    }
}

Vault :: (owner) {
    func addManager(newManager: Address) mutates (managers) {
        managers[managers.size] = newManager
    }
}

Vault :: (owner, managers) {
    func withdraw() {
        // ...
    }
}
```

---

### Payable functions
```flint
contract C {
    var stash: Wei = Wei(0)
}

C :: (any) {
    public init() {}

    @payable
    func pay(implicit value: inout Wei)
        mutates (stash)
    {
        stash.transfer(source: &value)
    }
}
```
- `@payable` is the only available attribute.
- Parameters are passed by value unless marked `inout`.
- State variables are read-only unless declared in `mutates()`.

---

## Fallback function
```flint
contract C {}

C :: (any) {
    public init() {}

    public fallback() {}

    // Not allowed (bug?):
    //@payable 
    //public fallback(implicit value: inout Wei) {}
}
```
- No equivalent for Solidity's `receive`.

---

## Structs
```flint
struct Rectangle {
    var width: Int = 0
    var height: Int = 0

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    func area() -> Int {
        return width * height
    }

    func area(scale: Int) -> Int {
        return width * height * scale
    }
}

contract C {}

C :: (any) {
    public init() {
        var rect: Rectangle = Rectangle(10, 20)
        var area: Int = rect.area()
    }
}
```
- Structs can have functions and initializers.
- Functions in structs can be overloaded.

---

## Traits
### Struct traits
```flint
struct trait Valuable {
    func value() -> Int

    func hasValue() -> Bool {
        return value() == 0
    }
}

struct Item: Valuable {
    var _value: Int = 0

    func value() -> Int {
        return _value
    }
}
```
- Traits describe functionality of a struct without defining it.
- Traits can provide default implementations of some functions.

---

### Contract traits
```flint
contract trait Sealable {
    self :: (any) {
        public func isSealed() -> Bool
        public func seal()
    }
}

contract Wallet: Sealable {
    var sealed: Bool = false
}

Wallet :: (any) {
    public init() {}

    public func isSealed() -> Bool {
        return sealed
    }

    public func seal() mutates(sealed) {
        sealed = true
    }
}
```

---

## Interfacing with foreign contracts
```flint
external trait IERC20 {
    func balanceOf(account: address) -> uint256
    func transfer(to: address, amount: uint256) -> bool
}

contract C {}

C :: (any) {
    public init() {}

    public func send10(tokenAddress: Address, to: Address) -> Bool {
        let token: IERC20 = IERC20(address: tokenAddress)
        return (call! token.transfer(
            to: to as! address,
            amount: 10 as! uint256
        )) as! Bool
    }
}
```

---

## Events
```flint
contract C {
    event Paid(sender: Address, amount: Wei)
}

C :: caller <- (any) {
    public init() {}

    @payable
    public func pay(implicit value: Wei) {
        emit Paid(sender: caller, amount: value)
    }
}
```

---

## Standard library
- `Asset` trait and `Wei` struct.
- `send()`, `fatalError()` and `assert()`

---

## Miscellaneous
- No inline assembly.
- No custom modifiers.
- Token and coin balances tracked via assets:
    - [FIP-0001 Introduce the Asset trait](https://github.com/flintlang/flint/blob/master/proposals/0001-asset-trait.md)
    - Somewhat flawed: does not account for transfers via `selfdestruct` and from coinbase.
- Checked arithmetic by default.
    - Unchecked calculations via dedicated operators: `&+`, `&-`, `&*`.

---

## Resources
- Compiler: https://github.com/flintlang/flint/
- [Flint Language Guide](https://github.com/flintlang/flint/blob/master/docs/language_guide.md)
- [FIP-0001 Introduce the Asset trait](https://github.com/flintlang/flint/blob/master/proposals/0001-asset-trait.md)
- [FIP-0002 Introduce Type States](https://github.com/flintlang/flint/blob/master/proposals/0002-type-states.md)
- [Solidity 0.4.25 documentation](https://docs.soliditylang.org/en/v0.4.25/)
- Paper: [Flint for Safer Smart Contracts](https://arxiv.org/abs/1904.06534)
