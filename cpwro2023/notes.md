## Introduction

## Groups of EVM languages

## Mainstream languages
- Languages in this category:
    - Solidity
    - Serpent
    - Vyper
    - Fe
    - Sway
- These are the main languages you'd choose from when starting a new project.

## Solidity
- Started in October 2014 by Christian Reitwießner.
- Originally a part of the Aleth project (formerly known as cpp-ethereum).
    - Later extracted into a standalone repository.
- The most popular smart-contract language on Ethereum and even on some other chains.
- Two alternative compilers exist: Solang and SOLL.
- Two code generators.
- Written in C++.
- Influences:
    - The most visible influence is C++: declarations, loops, overloading, conversions.
    - Early JavaScript influences: scoping and `var` keyword.
    - With time JavaScript influence waned, now mostly the `function` keyword and import syntax remain.
- High-level, imperative, curly-bracket language.
- Notable features:
    - Modeled after object-oriented languages: inheritance, enscapsulation, contracts are objects.
    - Mappings.
    - Logs are abstracted into events.
    - Modifiers modeled after Python's decorators.
    - Solidity allows dynamically allocating arbitrary amounts of memory at runtime.
    - Inline assembly.
- Solidity is one of the oldest but not the oldest smart contract language on the EVM.

## Serpent
- Started even before Solidity, in April 2014 by Vitalik Buterin.
    - Vitalik was the maintainer and main contributor.
    - Actively developed until about mid-2015. Very little activity after that.
- Written in C++.
- Audited by Zeppelin Solutions in July 2017. The audit revealed major issues with the language.
    - Findings: low quality code, untested, little documentation, flawed design.
    - Development stopped in October 2017. The language is dead.
    - Worth mentioning mainly due to its historical significance as a predecessor to Vyper.
- The language was used in the original Ethereum whitepaper.
- Low-level, imperative, weakly-typed, pythonic language.
- Notable features:
    - Variables are untyped. Any operation can be performed on any variable.
    - Hides stack manipulation with variables and control structures.
    - Has functions but only external ones.
- Limitations
    - There is no import system in the language. Each file is a separate contract.

## Vyper
- Development started in November 2016. Initiated by Vitalik Buterin.
    - Originally known as Viper, renamed in December 2017.
    - When Serpent development stopped, Vyper was seen as the natural successor.
    - Still active and maintained by the Vyper team.
- Written in Python.
- High-level, imperative, strongly-typed, pythonic language.
- Notable features:
    - The language is intentionally small and eschews superfluous features. More opinionated than Solidity.
    - Everything is bounded (loops, data structures).
    - Despite limitations, the language is modern and comparable with Solidity. Has contracts, functions, events, etc.
    - Explicit bounds allow for static memory management.
        - Local variables are stored in memory, not on stack.
        - The memory variables get static locations due to known upper bounds.
        - Less memory waste in certain scenarios compared to Solidity due to no repeated allocations.
        - More memory waste in certain scenarios compared to Solidity due having to allocate the maximum size.
        - No "stack too deep"
- Limitations
    - Static memory management requires disallowing recursive calls.
    - No OOP features known from Solidity like inheritance, overloading, modifiers.
    - One contract per file.
    - No inline assembly.

## Fe
- Started in August 2019, by David Sanders.
    - Originally known as Rust Vyper, started as an alternative Vyper compiler.
    - Gradually diverged and took on more and more features and syntax from Rust.
    - In September 2020 officially became its own language called Fe.
    - Still at the alpha stage.
- Written in Rust.
- High-level, imperative, strongly-typed, Rust-like language.
- Influenced by Python due to its history, gradually becoming more like Rust.
- Notable features:
    - Bounds on everything, like in Vyper.
    - Modern language comparable with Solidity. Has contracts, functions, events, etc.
    - Has imports.
    - Aims to have a rich standard library.
    - Already has some limited generics.
    - Uses dynamic memory allocation, like Solidity.
- Limitations
    - Follows Rust design, which means that inheritance, overloading and modifiers do not really fit the language.
    - There is no equivalent of Solidity's inline assembly.

## Sway
- Started in January 2021 by John Adler and Alex Hansen at Fuel Labs.
- Targets FuelVM, not EVM.
    - FuelVM is register-based.
    - UTXO model.
    - EVM backend is supposedly already under development as of March 2023. Not much is known about it.
- Writen in Rust.
- High-level, imperative, strongly-typed, Rust-like.
- Notable features:
    - Scripts and predicates
    - Libraries
    - Mappings
    - Structs, tuples, enums
    - Generics
    - Inline assembly
    - Proper memory management
    - Standard library
    - Borrow-checker


## Mainstream languages: influences
## Mainstream languages: timeline

## IR/assembly languages
## LLL/Vyper IR
- LLL = Lisp-Like Language
- Started in January 2014 by Gavin Wood.
    - First EVM language.
    - Originally a part of the Aleth project (formerly known as cpp-ethereum).
    - Written in C++.
    - Later maintained together with the Solidity compiler.
- Vyper implementation in November 2016 by Vitalik Buterin.
    - Written in Python.
    - Used as IR for the Vyper compiler.
- Solidity/LLL is deprecated and was removed from the Solidity repository in Solidity 0.6.2 (January 2020).
- Vyper/LLL lives on but diverged from the original LLL enough that it was renamed to just Vyper IR in Vyper 0.3.2 (April 2022).
- Low-level, imperative, untyped, Lisp-like.

## Yul
- Started in April 2017 by Christian Reitwießner and Alex Beregszaszi.
    - First code appeared in Solidity 0.4.11.
    - Originally called JULIA, later renamed to IULIA and finally Yul in March 2018.
    - JULIA = Joyfully Universal Language for (Inline) Assembly.
- Written in C++.
- Used as IR for the Solidity compiler.
    - Later also by other languages: Fe, Flint, Logikon.
- Low-level, imperative, untyped, curly-bracket.

## Yul+
- Started in January 2020 by Nick Dodson at Fuel Labs.
- Development stopped in February 2022.
- Written in Rust.
- Low-level, procedural, untyped, curly-bracket.

## ETK assembly
- Started in February 2021 by lightclient and Sam Wilson.
- Still considered experimental
- ETK = EVM ToolKit.
- Written in Rust.
- Low-level, imperative, untyped, assembly-like.

## Huff
- Started in December 2019 by Zachary Williamson from AZTEC Protocol.
    - Initial implementation in JavaScript.
- In May 2022 reimplemented from scratch in Rust.
- Low-level, imperative, untyped, assembly-like.

## Sonatina
- Started in September 2021 by Yoshitomo Nakanishi.
- Written in Rust.
- Low-level, imperative, strongly-typed, assembly-like.

## IR/assembly languages: influences
## IR/assembly languages: timeline

## Experimental languages: influences

- There are many languages going in alternative directions, that ultimately were abandoned.
- A lot of variety compared to mainstream languages. Diverse influences and paradigms.
- Mutan was an early language from the era of Serpent and LLL.
    - Quickly deprecated (March 2015).
- Flint is one of the more developed experimental languages, addressing weaknesses in Solidity.
    - Ultimately it's still an academic language with no production use, interesting mostly for its ideas.
    - Docker image with the compiler:
        ```bash
        docker pull cameel/flint-bionic
        ```
- Logikon is a short-lived experiment by Solidity developers in creating a Prolog-like language.
- Lira is substantially different that other languages here.
    - DSL for expressing financial contracts.
    - Aimed at users with a financial background rather than programmers.


## Experimental languages: timeline

## Other languages

## Endcard
