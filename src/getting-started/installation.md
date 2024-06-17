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
    network::{eip2718::Encodable2718, EthereumWallet, TransactionBuilder},
    primitives::U256,
    providers::{Provider, ProviderBuilder},
    rpc::types::TransactionRequest,
    signers::local::PrivateKeySigner,
};
```

### Features

The [`alloy`](https://github.com/alloy-rs/alloy/tree/main/crates/alloy) meta-crate defines a number of [feature flags](https://github.com/alloy-rs/alloy/blob/main/crates/alloy/Cargo.toml):

Default

- `std`
- `reqwest`

Full, a set of the most commonly used flags to get started with `alloy`.

- `full`

General
- `consensus`
- `contract`
- `eips`
- `genesis`
- `network`
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
- `rpc-types-admin`
- `rpc-types-anvil`
- `rpc-types-beacon`
- `rpc-types-debug`
- `rpc-types-engine`
- `rpc-types-eth`
- `rpc-types-json`
- `rpc-types-trace`
- `rpc-types-txpool`

Signers
- `signers`
- `signer-aws`
- `signer-gcp`
- `signer-ledger`
- `signer-ledger-browser`
- `signer-ledger-node`
- `signer-local`
- `signer-trezor`
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

- [alloy](https://github.com/alloy-rs/alloy/tree/main/crates/alloy) - Meta-crate for the entire project, including [`alloy-core`](https://docs.rs/alloy-core)
- [alloy-consensus](https://github.com/alloy-rs/alloy/tree/main/crates/consensus) - Ethereum consensus interface
- [alloy-contract](https://github.com/alloy-rs/alloy/tree/main/crates/contract) - Interact with on-chain contracts
- [alloy-eips](https://github.com/alloy-rs/alloy/tree/main/crates/eips) - Ethereum Improvement Proposal (EIP) implementations
- [alloy-genesis](https://github.com/alloy-rs/alloy/tree/main/crates/genesis) - Ethereum genesis file definitions
- [alloy-json-rpc](https://github.com/alloy-rs/alloy/tree/main/crates/json-rpc) - Core data types for JSON-RPC 2.0 clients
- [alloy-network](https://github.com/alloy-rs/alloy/tree/main/crates/network) - Network abstraction for RPC types
- [alloy-node-bindings](https://github.com/alloy-rs/alloy/tree/main/crates/node-bindings) - Ethereum execution-layer client bindings
- [alloy-provider](https://github.com/alloy-rs/alloy/tree/main/crates/provider) - Interface with an Ethereum blockchain
- [alloy-pubsub](https://github.com/alloy-rs/alloy/tree/main/crates/pubsub) - Ethereum JSON-RPC [publish-subscribe](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) tower service and type definitions
- [alloy-rpc-client](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-client) - Low-level Ethereum JSON-RPC client implementation
- [alloy-rpc-types](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types) - Meta-crate for all Ethereum JSON-RPC types
  - [alloy-rpc-types-admin](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-admin) - Ethereum RPC admin types
  - [alloy-rpc-types-anvil](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-anvil) - RPC types for the Anvil development node
  - [alloy-rpc-types-beacon](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-beacon) - Ethereum RPC-related types for the Beacon API
  - [alloy-rpc-types-engine](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-engine) - Ethereum execution-consensus layer (engine) API RPC types
  - [alloy-rpc-types-eth](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-eth) - Ethereum RPC-related types for Alloy
  - [alloy-rpc-types-trace](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-trace) - Ethereum RPC trace types
  - [alloy-rpc-types-txpool](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-txpool) - Ethereum RPC txpool types
- [alloy-serde](https://github.com/alloy-rs/alloy/tree/main/crates/serde) - Serde related helpers for Alloy
- [alloy-signer](https://github.com/alloy-rs/alloy/tree/main/crates/signer) - Ethereum signer abstraction
  - [alloy-signer-aws](https://github.com/alloy-rs/alloy/tree/main/crates/signer-aws) - [AWS KMS](https://aws.amazon.com/kms) signer implementation
  - [alloy-signer-gcp](https://github.com/alloy-rs/alloy/tree/main/crates/signer-gcp) - [GCP KMS](https://cloud.google.com/kms) signer implementation
  - [alloy-signer-ledger](https://github.com/alloy-rs/alloy/tree/main/crates/signer-ledger) - [Ledger](https://www.ledger.com) signer implementation
  - [alloy-signer-local](https://github.com/alloy-rs/alloy/tree/main/crates/signer-local) - Local (private key, keystore, mnemonic, YubiHSM) signer implementations
  - [alloy-signer-trezor](https://github.com/alloy-rs/alloy/tree/main/crates/signer-trezor) - [Trezor](https://trezor.io) signer implementation
- [alloy-transport](https://github.com/alloy-rs/alloy/tree/main/crates/transport) - Low-level Ethereum JSON-RPC transport abstraction
  - [alloy-transport-http](https://github.com/alloy-rs/alloy/tree/main/crates/transport-http) - HTTP transport implementation
  - [alloy-transport-ipc](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ipc) - IPC transport implementation
  - [alloy-transport-ws](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ws) - WS transport implementation

`alloy-core` consists out of the following crates:

- [alloy-core](https://github.com/alloy-rs/core/tree/main/crates/core) - Meta-crate for the entire project
- [alloy-dyn-abi](https://github.com/alloy-rs/core/tree/main/crates/dyn-abi) - Run-time [ABI](https://docs.soliditylang.org/en/latest/abi-spec.html) and [EIP-712](https://eips.ethereum.org/EIPS/eip-712) implementations
- [alloy-json-abi](https://github.com/alloy-rs/core/tree/main/crates/json-abi) - Full Ethereum [JSON-ABI](https://docs.soliditylang.org/en/latest/abi-spec.html#json) implementation
- [alloy-primitives](https://github.com/alloy-rs/core/tree/main/crates/primitives) - Primitive integer and byte types
- [alloy-sol-macro-expander](https://github.com/alloy-rs/core/tree/main/crates/sol-macro-expander) - Expander used in the Solidity to Rust procedural macro
- [alloy-sol-macro-input](https://github.com/alloy-rs/core/tree/main/crates/sol-macro-input) - Input types for [`sol!`](https://docs.rs/alloy-sol-macro/latest/alloy_sol_macro/macro.sol.html)-like macros
- [alloy-sol-macro](https://github.com/alloy-rs/core/tree/main/crates/sol-macro) - The [`sol!`](https://docs.rs/alloy-sol-macro/latest/alloy_sol_macro/macro.sol.html) procedural macro
- [alloy-sol-type-parser](https://github.com/alloy-rs/core/tree/main/crates/sol-type-parser) - A simple parser for Solidity type strings
- [alloy-sol-types](https://github.com/alloy-rs/core/tree/main/crates/sol-types) - Compile-time [ABI](https://docs.soliditylang.org/en/latest/abi-spec.html) and [EIP-712](https://eips.ethereum.org/EIPS/eip-712) implementations
- [syn-solidity](https://github.com/alloy-rs/core/tree/main/crates/syn-solidity) - [`syn`](https://github.com/dtolnay/syn)-powered Solidity parser