# External dispatch

## Functions on the EVM
- External functions do not exist as an EVM primitive. The EVM view is much simpler:
    - There are only contracts. A contract is a blob of bytecode with a single entry point.
    - There are internal jumps but these may represent various things, not just functions.
- EVM Object Format (EOF) will add first-class functions eventually.

## Dispatch
- High-level smart contract languages simulate external functions via the dispatch.
- Dispatch is a big switch that jumps to the right place in the code based on function selector.
- The fallback function is just the default case of the switch.
- Usually the set of available functions is static, but does not have to be.
