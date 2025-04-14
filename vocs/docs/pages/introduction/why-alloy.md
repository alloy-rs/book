## Why alloy

### Problems developers face with existing tooling

- Middleware complexity: ethers-rs's monolithic middleware system created confusing dependency chains and unpredictable interactions
- Multi-chain friction: Supporting networks beyond Ethereum required feature flags that led to either code duplication or unsafe type handling
- Performance bottlenecks: Critical operations like U256 arithmetic and ABI encoding were unnecessarily slow, impacting time-sensitive applications
- Excessive boilerplate: Required wrapping providers in Arc<M> and verbose contract interaction patterns
- Contract interaction verbosity: Separated ABI handling and complex bindings generation created friction in the development process
- Library maintenance burden: Architectural limitations made it increasingly difficult to add features without breaking changes

### How Alloy Solves These Problems

[Alloy](https://github.com/alloy-rs/alloy) consists of a number of crates that provide a range of functionality essential for interfacing with any Ethereum-based blockchain.


[Alloy](https://github.com/alloy-rs/alloy) is the high-performance successor to ethers-rs, built from the ground up to solve real problems faced by Ethereum developers. With up to 60% faster U256 operations, 10x faster ABI encoding, and a revolutionary provider architecture, Alloy eliminates the complexity of middleware chains while providing true multi-chain support without feature flags. The intuitive `sol!` macro lets you write Solidity directly in your Rust code, making contract interations as simple as it can get. Already powering major projects like Foundry, Reth, and Arbitrum Stylus, Alloy v1.0 delivers the performance, reliability, and ergonomics that modern Ethereum development demands.

Alloy brings the following improvements compared to other tooling: 
- Layered architecture: Replaces monolithic middleware with distinct layers and fillers that can be composed without unexpected interactions. 
- Network trait: Provides true type-safe multi-chain support without feature flags, allowing clean integration with any EVM-compatible chain
- Optimized primitives: Delivers up to 60% faster U256 operations and 10x faster ABI encoding through completely rewritten core components
- Object-safe providers: Eliminates the need for Arc wrapping with cleaner, more intuitive provider and signer implementations
- `sol!` macro: Enables writing Solidity directly in Rust code, dramatically simplifying contract interactions and reducing context switching
- Clean API design: Built from the ground up with a focus on developer experience, stability, and future extensibility