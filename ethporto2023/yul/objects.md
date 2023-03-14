# Yul objects vs bytecode
## How contracts are deployed
- The bytecode in a transaction creating a contract is the creation bytecode.
- The bytecode that ends up responding to calls on chain is the runtime bytecode.
- Creation code runs only once. Produces the runtime bytecode.
- Simplest case: runtime bytecode is embedded inside creation bytecode and just copied.
- More complex: immutable values inserted into runtime bytecode at creation time.

## Subassemblies
- Bytecode has no hard structure imposed by EVM.
    - EVM Object Format (EOF) will eventually change that.
- Many compilers do use internal structure: subassemblies and data sections.
- Subassemblies can be deeply nested.
- Subassemblies are just separate chunks of executable code.
    - Creation vs runtime code.
    - Nested contracts embedded for deployment with `CREATE` or `CREATE2` at runtime.

## Yul objects
- Yul objects compile to subassemblies.
- Can contain data chunks.
- Distinction between creation and runtime objects (also affects optimization).
