# Memory management

## Memory areas on the EVM
- Contracts running on the EVM can freely read and write 3 main areas:
    - storage: random access, persists between external calls
    - memory: (mostly) random access, resets between external calls
    - stack: limited access, resets between external calls
- Different languages abstract accessing these areas to different extent.

## Stack
- EVM is a stack machine - the stack is the replacement for registers in other architectures.
- Stack is the place where EVM opcodes take and return values.
- It has 1024 32-byte slots but only top 16 are accessible at any given moment.
- In all but the very low-level languages, the stack is managed by the compiler and hidden from the programmer.

## Memory
- Memory is byte-addressable.
- EVM tracks the highest address accessed by a contract so far  during the call (`MSIZE`).
    - Extra gas is changed for the amount of memory accessed.
    - The cost is O(n^2), but linear (3 GAS per word) under 704 bytes.
        It gets expensive when the memory usage is high.
- There are no opcodes that operate on memory directly.
    Access is relatively cheap but values have to be loaded onto the stack and then stored back into memory.

## Storage
- Storage is extremely expensive compared to memory.
    - `MSTORE`: 3 GAS, `SSTORE`: up to 20000 GAS.
- No extra penalty for accessing higher addresses.
    Free random access.
- There are no opcodes that operate on storage directly.

## Memory management in Solidity
- Solidity uses stack to store parameters and local variables of value types.
- Reference types can be stored in memory or in storage - decision is up to the programmer.
- Very simple memory management model:
    - Once allocated, memory is never freed.
    - Free memory pointer tracks the first unallocated address.
        - Value stored in memory at address `0x40`.
        - Unrelated to the `MSIZE` opcode.
- Allows dynamic types of size limited only by available memory and gas.
- Stack access is cheap but the available slots are easily exhausted (the infamous "Stack too deep" error).
    - "Stack too deep" can be avoided by moving variables to memory.

## Memory management in Vyper
- Vyper stores parameters and local variables in memory.
- Completely static memory allocation: every variable always has the same address, computed at compilation time.
    - Possible only due to the limitations of the language:
        - All types have static maximum size.
        - Recursive calls are not allowed.
    - Static addresses reduce the cost of moving values to/from the stack.
- This model is new in 0.3.0. Calling convention changed several times.
    - Initially there were no true internal calls.
        Every call would be external to give each function a fresh memory space.
    - Later this was changed.
        Before a call, the variables of the previous function would be saved on the stack and whole memory handed over to the callee.
