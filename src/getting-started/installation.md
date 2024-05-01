## Installation

To install [`alloy`](https://github.com/alloy-rs/alloy) run the following command:

```sh
cargo add --git https://github.com/alloy-rs/alloy
```

For most use cases it is recommended to use the [`alloy`](https://github.com/alloy-rs/alloy/tree/main/crates/alloy) meta-crate and enabling feature flags.

It is recommended to pin to a specific commit hash as follows until `alloy` releases its first official version of all crates:

```toml
alloy = {
  git = "https://github.com/alloy-rs/alloy",
  rev = "<COMMIT_HASH>",
  features = [
    "contract",
    "providers",
    "..."
  ]
}
```

Alternatively one can directly use individual crates as follows:

```toml
alloy-provider = {
  git = "https://github.com/alloy-rs/alloy",
  rev = "<COMMIT_HASH>"
  features = [
    "ws",
    "ipc",
    "..."
  ]
}
```

After `alloy` as a dependency you can now import `alloy` as follows:

```rust,ignore
use alloy::{
    network::{eip2718::Encodable2718, EthereumSigner, TransactionBuilder},
    node_bindings::Anvil,
    primitives::U256,
    providers::{Provider, ProviderBuilder},
    rpc::types::eth::TransactionRequest,
    signers::wallet::LocalWallet,
};
```

### Features

The [`alloy`](https://github.com/alloy-rs/alloy/tree/main/crates/alloy) meta-crate defines a number of feature flags.

The main [feature flags](https://github.com/alloy-rs/alloy/blob/main/crates/alloy/Cargo.toml) for the `alloy` meta-crate are:

Default
- `std`
- `reqwest`

General
- `contract`
- `consensus`
- `eips`
- `network`
- `genesis`
- `node-bindings`

Providers
- `providers`
- `provider-http`
- `provider-ipc`
- `provider-ws`

RPC
- `rpc`
- `json-rpc`
- `rpc-client`
- `rpc-client-ipc`
- `rpc-client-ws`
- `rpc-types`
- `rpc-types-eth`
- `rpc-types-engine`
- `rpc-types-json`
- `rpc-types-trace`

Signers
- `signers`
- `signer-aws`
- `signer-gcp`
- `signer-ledger`
- `signer-ledger`
- `signer-trezor-browser`
- `signer-trezor-node`
- `signer-wallet`
- `signer-keystore`
- `signer-mnemonic`
- `signer-mnemonic-all-languages`
- `signer-yubihsm`

By default `alloy` uses [`reqwest`](https://crates.io/crates/reqwest) as HTTP client. Alternatively one can switch to [`hyper`](https://crates.io/crates/hyper).
The `reqwest` and `hyper` feature flags are mutually exclusive.
  
For a complete overview of `alloy` feature flags refer to [`alloy's Cargo.toml`](https://github.com/alloy-rs/alloy/blob/main/crates/alloy/Cargo.toml)

The feature flags largely correspond with and enable features from the following individual crates.

### Crates

`alloy` consists out of the following crates:

- [alloy](https://github.com/alloy-rs/alloy/tree/main/crates/alloy) - Meta-crate for the entire project, including [alloy-core](https://github.com/alloy-rs/core/tree/main/crates/core)
- [alloy-consensus](https://github.com/alloy-rs/alloy/tree/main/crates/consensus) - Ethereum consensus interface
- [alloy-contract](https://github.com/alloy-rs/alloy/tree/main/crates/contract) - Interact with on-chain contracts
- [alloy-eips](https://github.com/alloy-rs/alloy/tree/main/crates/eips) - Ethereum Improvement Proposal (EIP) implementations
- [alloy-genesis](https://github.com/alloy-rs/alloy/tree/main/crates/genesis) - Ethereum genesis file definitions
- [alloy-json-rpc](https://github.com/alloy-rs/alloy/tree/main/crates/json-rpc) - Core data types for JSON-RPC 2.0 clients
- [alloy-network](https://github.com/alloy-rs/alloy/tree/main/crates/network) - Network abstraction for RPC types
- [alloy-node-bindings](https://github.com/alloy-rs/alloy/tree/main/crates/node-bindings) - Ethereum execution-layer client bindings
- [alloy-provider](https://github.com/alloy-rs/alloy/tree/main/crates/provider) - Interface with an Ethereum blockchain
- [alloy-pubsub](https://github.com/alloy-rs/alloy/tree/main/crates/pubsub) - Ethereum JSON-RPC `publish-subscribe` tower service and type definitions
- [alloy-rpc-client](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-client) - Low-level Ethereum JSON-RPC client implementation
- [alloy-rpc-types](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types) - Ethereum JSON-RPC types
  - [alloy-rpc-types-anvil](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-anvil) - RPC types for Anvil, Hardhat, and Ganache dev nodes
  - [alloy-rpc-types-engine](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-engine) - Ethereum execution-consensus layer (engine) API RPC types
  - [alloy-rpc-types-trace](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-trace) - Ethereum RPC trace types
- [alloy-serde](https://github.com/alloy-rs/alloy/tree/main/crates/serde) - `Serde` related helpers
- [alloy-signer](https://github.com/alloy-rs/alloy/tree/main/crates/signer) - Ethereum signer abstraction
  - [alloy-signer-aws]( https://github.com/alloy-rs/alloy/tree/main/crates/signer-aws) - `AWS KMS` signer implementation
  - [alloy-signer-gcp](https://github.com/alloy-rs/alloy/tree/main/crates/signer-gcp) - `GCP KMS` signer implementation
  - [alloy-signer-ledger](https://github.com/alloy-rs/alloy/tree/main/crates/signer-ledger) - `Ledger` signer implementation
  - [alloy-signer-trezor](https://github.com/alloy-rs/alloy/tree/main/crates/signer-trezor)  - `Trezor` signer implementation
  - [alloy-signer-wallet](https://github.com/alloy-rs/alloy/tree/main/crates/signer-wallet)  - `sepc256k1 ECDSA` and `YubiHSM` signer implementations
- [alloy-transport](https://github.com/alloy-rs/alloy/tree/main/crates/transport) - Low level Ethereum JSON-RPC transport abstraction
  - [alloy-transport-http](https://github.com/alloy-rs/alloy/tree/main/crates/transport-http) - HTTP transport implementation
  - [alloy-transport-ipc](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ipc) - IPC transport implementation
  - [alloy-transport-ws](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ws) - WS transport implementation

`alloy-core` consists out of the following crates:

- [alloy-core](https://github.com/alloy-rs/core/tree/main/crates/core) - Meta-crate for the entire project
- [alloy-dyn-abi](https://github.com/alloy-rs/core/tree/main/crates/dyn-abi) - Run-time `ABI` and `EIP-712` implementations
- [alloy-json-abi](https://github.com/alloy-rs/core/tree/main/crates/json-abi) - Full Ethereum `JSON-ABI` implementation
- [alloy-primitives](https://github.com/alloy-rs/core/tree/main/crates/primitives) - Primitive integer and byte types
- [alloy-sol-macro-input](https://github.com/alloy-rs/core/tree/main/crates/sol-macro-input) - Input types for `sol!`-like macros
- [alloy-sol-macro](https://github.com/alloy-rs/core/tree/main/crates/sol-macro) - The `sol!` procedural macro
- [alloy-sol-type-parser](https://github.com/alloy-rs/core/tree/main/crates/sol-type-parser) - A simple parser for Solidity type strings
- [alloy-sol-types](https://github.com/alloy-rs/core/tree/main/crates/sol-types) - Compile-time `ABI` and `EIP-712` implementations
- [syn-solidity](https://github.com/alloy-rs/core/tree/main/crates/syn-solidity) - [syn`]-powered Solidity parser
