## Using big numbers

Ethereum uses big numbers (also known as "bignums" or "arbitrary-precision integers") to represent certain values in its codebase and in blockchain transactions. This is necessary because the [EVM](https://ethereum.org/en/developers/docs/evm) operates on a 256-bit word size, which is different from the usual 32-bit or 64-bit of modern machines. This was chosen for the ease of use with 256-bit cryptography (such as [Keccak-256](https://github.com/ethereum/eth-hash) hashes or [secp256k1](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm) signatures).

It is worth noting that Ethereum is not the only blockchain or cryptocurrency that uses big numbers. Many other blockchains and cryptocurrencies also use big numbers to represent values in their respective systems.

### Utilities

In order to create an application, it is often necessary to convert between the representation of values that is easily understood by humans (such as ether) and the machine-readable form that is used by contracts and math functions (such as wei). This is particularly important when working with Ethereum, as certain values, such as balances and gas prices, must be expressed in wei when sending transactions, even if they are displayed to the user in a different format, such as ether or gwei. To help with this conversion, `alloy::primitives::utils` provides two functions, [`parse_units`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/utils/units.rs) and [`format_units`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/utils/units.rs), which allow you to easily convert between human-readable and machine-readable forms of values. parse_units can be used to convert a string representing a value in ether, such as "1.1", into a big number in wei, which can be used in contracts and math functions. format_units can be used to convert a big number value into a human-readable string, which is useful for displaying values to users.

### Math Operations

```rust
// [!include ~/snippets/big-numbers/examples/math_operations.rs]
```

### Parsing and formatting units

```rust
// [!include ~/snippets/big-numbers/examples/math_utilities.rs]
```
