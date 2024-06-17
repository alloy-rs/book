## Installation

[Alloy](https://github.com/alloy-rs/alloy) consists of a number of crates that provide a range of functionality essential for interfacing with any Ethereum-based blockchain.

The easiest way to get started is to add the `alloy` crate with the `full` feature flag from the command-line using Cargo:

```sh
cargo add alloy --features full
```

Alternatively, you can add the following to your `Cargo.toml` file:

```toml
alloy = { version = "0.1", features = ["full"] }
```

For a more fine-grained control over the features you wish to include, you can add the individual crates to your `Cargo.toml` file, or use the `alloy` crate with the features you need.

A comprehensive list of available features can be found on [docs.rs](https://docs.rs/crate/alloy/latest/features) or in the [`alloy` crate's `Cargo.toml`](https://github.com/alloy-rs/alloy/blob/main/crates/alloy/Cargo.toml).

After `alloy` as a dependency you can now import `alloy` as follows:

```rust,ignore
use alloy::{
    network::{eip2718::Encodable2718, EthereumWallet, TransactionBuilder},
    primitives::U256,
    providers::{Provider, ProviderBuilder},
    rpc::types::TransactionRequest,
    signers::local::PrivateKeySigner,
};
```
