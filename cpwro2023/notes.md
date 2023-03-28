### Serpent
#### History
- Serpent or LLL first?
    - First mention of CLL in January 2014 on EF blog.
    - First LLL commits in Aleth in January 2014.
- Written in C++.

#### Characteristics
- Low level compared to newer languages but has high-level features.
    - I'd draw the line at EVM opcodes as a first-class language primitive.
- Ironically, the C-Like Language was actually Python-like.

#### Highlights
- Hides stack manipulation.
- External functions means ABI.
- Its storage arrays are effectively mappings.
- Already a primitive memory allocation scheme.

#### Drawbacks
- No types associated with variables.
    - Has literals, e.g. strings, but size limited and in the end stored as 256-bit numbers.
    - Any operation can be performed on any variable.
- No dynamic structures in memory means also no unlimited size strings.
- Without external functions calls are expensive.
    - But gas used to be much less of an issue.
- No internal functions and no imports means lots of code in a single function.
- Security:
    - OpenZeppelin audit in July 2017.
    - Findings: low quality code, untested, little documentation, flawed design.

### Solidity
#### History
- Started in October 2014.
- Originally part of Aleth, later extracted.
- Two alternative compilers exist: Solang and SOLL.
- Written in C++.

#### Influences
- C++: declarations, loop/if syntax, overloading, conversions.
- JavaScript (initially): scoping and `var` keyword.
    - Now just a few leftovers: `function` keyword, import syntax.
- Python: modifiers (decorators), inheritance, assignment semantics.

#### Highlights
- More effective abstractions over low level concepts:
    - OOP features: inheritance, enscapsulation, contracts are objects.
    - Events: abstraction over logs.
    - Syntax sugar: modifiers
- Inline assembly: escape hatch from abstractions for more control
- Dynamic memory allocation scheme addressing the need for dynamic types.
- Dynamic types also in storage.

#### Drawbacks
- More features means more complexity.
- Complex abstractions require a good optimizer.
    - Introduction of Yul to allow for more high-level optimizations.
- "Stack too deep" is a natural consequence of storing variables on the limited stack of the EVM.

### Vyper
#### History
- Started in November 2016, renamed from Viper in December 2017.
- Written in Python.

#### Highlights
- Inline assembly can be a hindrance to optimization and requires making assumptions.
- Despite limitations, the language is modern and comparable with Solidity.
- Lack of recursive calls helps keep static locations for variables.
    - Lower cost of loading them on the stack.
- Vyper used to have only external calls to ensure static variable locations.
- Vyper added checked arithmetic in 2018.
- Some people just **really** like Python.

#### Drawbacks
- In Solidity you can work around of lots of limitations with inline assembly.
- More memory waste in certain scenarios compared to Solidity due having to allocate the maximum size.
    - Less memory waste in certain scenarios compared to Solidity due to no repeated allocations.

### Fe
#### History
- Started in August 2019, renamed in September 2020.
- Current Fe team is a part of EF, replaced Vyper.
- Still at the alpha stage.
- Written in Rust.

#### Highlights
- May get inline assembly in the form of `unsafe` blocks.
- Aims to have a rich standard library.
- Already has some limited generics.

#### Drawbacks
- Due to compiling to Yul, is closer to Solidity's memory model than to Vyper's.
    - May be seen as a downside when it comes to "Stack too deep" errors.
    - But these problems are also being addressed at Yul level.

### Sway
#### History
- Started in January 2021 at Fuel Labs.
- EVM backend is supposedly already under development as of March 2023. Not much is known about it.
- Writen in Rust.

#### Highlights
- Scripts allow users to atomically call multiple contracts without deploying a contract.

#### Drawbacks
- Rust was not designed from the ground up for environment as limited as EVM, which may and up being a hindrance.

### LLL
#### History
- Probably the first language on the EVM.
- Started in January 2014.
    - Written in C++.
- Vyper implementation in November 2016 by Vitalik Buterin.
    - Written in Python.
    - Used as IR for the Vyper compiler.
- Solidity/LLL removed from the Solidity repository in Solidity 0.6.2 (January 2020).

### Yul
#### History
- First code appeared in Solidity 0.4.11.
- Renamed Yul in March 2018.
- JULIA = Joyfully Universal Language for (Inline) Assembly.
- Written in C++.
- Used as IR for the Solidity compiler.

#### Drawbacks
- Extensive use of `switch` is due to`if`s not having `else` clauses.

### Yul+
#### History
- Started in January 2020 by Nick Dodson at Fuel Labs.
- Development stopped in February 2022.
- Written in Rust.

## ETK assembly
#### History
- Started in February 2021.
- Written in Rust.

### Huff
#### History
- Started in December 2019 at AZTEC Protocol.

### Sonatina
#### History
- Started in September 2021.
- Written in Rust.

# Experimental languages
- Many alternative approaches, ultimately abandoned.
- A lot of variety compared to mainstream languages. Diverse influences and paradigms.
- Mutan was an early language from the era of Serpent and LLL.
    - Quickly deprecated (March 2015).
- Flint is one of the more developed experimental languages, addressing weaknesses in Solidity.
    - Ultimately it's still an academic language with no production use, interesting mostly for its ideas.
    - Targeting also Libra.
    - Docker image with the compiler:
        ```bash
        docker pull cameel/flint-bionic
        ```
- Logikon was a short-lived experiment by Solidity developers in creating a Prolog-like language.
- Lira is substantially different that other languages here.
    - DSL for expressing financial contracts.
    - Aimed at users with a financial background rather than programmers.
