## Reference

[ethers-rs](https://github.com/gakonst/ethers-rs/) is in the process of being deprecated in favor of [Alloy](https://github.com/alloy-rs/) and [Foundry](https://github.com/foundry-rs/).

The following is a reference guide for finding the migration path for your specific crate, dependency or information source.

### Documentation

- Book: [`ethers-rs/book`](https://github.com/gakonst/ethers-rs/tree/master/book) `->` [`alloy-rs/book`](https://github.com/alloy-rs/book)

### Examples

- Examples: [`ethers-rs/examples`](https://github.com/gakonst/ethers-rs/tree/master/examples) `->` [`alloy-rs/examples`](https://github.com/alloy-rs/examples)

### Crates

- Meta-crate: [`ethers`](https://github.com/gakonst/ethers-rs/tree/master/ethers) `->` [`alloy`](https://github.com/alloy-rs/alloy/tree/main/crates/alloy)
- Address book: [`ethers::addressbook`](https://github.com/gakonst/ethers-rs/tree/master/ethers-addressbook) `->` Not planned
- Compilers [`ethers::solc`](https://github.com/gakonst/ethers-rs/tree/master/ethers-solc) `->` [`foundry-compilers`](https://github.com/foundry-rs/compilers)
- Contract: [`ethers::contract`](https://github.com/gakonst/ethers-rs/tree/master/ethers-contract) `->` [`alloy::contract`](https://github.com/alloy-rs/alloy/tree/main/crates/contract)
- Core: [`ethers::core`](https://github.com/gakonst/ethers-rs/tree/master/ethers-core) `->` [`alloy::core`](https://github.com/alloy-rs/core)
  - Types: [`ethers::core::types::*`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types) `->` See [Types](#types) section
- Etherscan [`ethers::etherscan`](https://github.com/gakonst/ethers-rs/tree/master/ethers-etherscan) `->` [`foundry-block-explorers`](https://github.com/foundry-rs/block-explorers)
- Middleware [`ethers::middleware`](https://github.com/gakonst/ethers-rs/tree/master/ethers-middleware) `->` Fillers [`alloy::provider::{fillers, layers}`](https://github.com/alloy-rs/alloy/tree/main/crates/provider/src)
  - Gas oracle [`ethers::middleware::GasOracleMiddleware`](https://github.com/gakonst/ethers-rs/blob/master/ethers-middleware/src/gas_oracle/middleware.rs) `->` Gas filler [`alloy::provider::GasFiller`](https://github.com/alloy-rs/examples/blob/main/examples/fillers/examples/gas_filler.rs)
  - Nonce manager [`ethers::middleware::NonceManagerMiddleware`](https://github.com/gakonst/ethers-rs/tree/master/ethers-middleware/src/nonce_manager.rs) `->` Nonce filler [`alloy::provider::NonceFiller`](https://github.com/alloy-rs/alloy/tree/main/crates/provider/src/fillers/nonce.rs)
  - Signer [`ethers::middleware::Signer`](https://github.com/gakonst/ethers-rs/blob/master/ethers-middleware/src/signer.rs) `->` Signer filler [`alloy::provider::SignerFiller`](https://github.com/alloy-rs/alloy/blob/main/crates/provider/src/fillers/signer.rs)
- Providers [`ethers::providers`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers) `->` Provider [`alloy-provider`](https://github.com/alloy-rs/alloy/tree/main/crates/provider)
- Transports [`ethers::providers::transports`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports) `->` [`alloy::transports`](https://github.com/alloy-rs/alloy/tree/main/crates/transport)
  - HTTP [`ethers::providers::Http`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports/http.rs) `->` [`alloy::transports::http`](https://github.com/alloy-rs/alloy/tree/main/crates/transport-http)
  - IPC [`ethers::providers::Ipc`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports/ipc.rs) `->` [`alloy::transports::ipc`](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ipc)
  - WS [`ethers::providers::Ws`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports/ws) `->` [`alloy::transports::ws`](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ws)
- Signers [`ethers::signers`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers) `->` Signer [`alloy::signers`](https://github.com/alloy-rs/alloy/tree/main/crates/signer)
  - AWS [`ethers::signers::aws::*`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/aws) `->` [`alloy::signers::aws`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-aws)
  - Ledger [`ethers::signers::ledger::*`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/ledger) `->` [`alloy::signers::ledger`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-ledger)
  - Trezor [`ethers::signers::trezor::*`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/trezor) `->` [`alloy::signer::trezor`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-trezor)
  - Wallet [`ethers::signers::wallet::*`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/wallet) `->` [`alloy::signer::wallet`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-wallet)

### ABI

<!-- https://github.com/alloy-rs/core/tree/main/crates/dyn-abi
https://github.com/alloy-rs/core/tree/main/crates/json-abi -->

### Types

#### Primitives

- Address [`ethers::types::Address`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::Address`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- U64 [`ethers::types::U64`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::U64`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- U128 [`ethers::types::U128`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::U128`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- U256 [`ethers::types::U256`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::U256`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- U512 [`ethers::types::U512`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::U512`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- H32 [`ethers::types::H32`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::aliases::B32`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- H64 [`ethers::types::H64`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::B64`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- H128 [`ethers::types::H128`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::B128`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- H160 [`ethers::types::H160`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::B160`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- H256 [`ethers::types::H256`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::B256`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- H512 [`ethers::types::H512`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::B512`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- Bloom [`ethers::types::Bloom`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::Bloom`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)
- TxHash [`ethers::types::TxHash`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) `->` [`alloy::primitives::TxHash`](https://github.com/alloy-rs/core/blob/main/crates/primitives/src/lib.rs)

Due to a [limitation](https://github.com/alloy-rs/core/issues/554#issuecomment-1978620017) in `ruint` BigEndianHash [`ethers::types::BigEndianHash`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/mod.rs) can be expressed as follows:

```rust,ignore
// `U256` => `B256`
let x = B256::from(u256);

// `B256` => `U256`
let x: U256 = b256.into();
let x = U256::from_be_bytes(b256.to_be_bytes())
```

#### RPC

- Chains: [`ethers::types::Chain`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/chain.rs) `->` [`alloy-rs/chains`](https://github.com/alloy-rs/chains)
- Trace [`ethers::types::trace`](https://github.com/gakonst/ethers-rs/tree/master/ethers-core/src/types/trace) `->` [`alloy::rpc::types::trace`](https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-trace)
- Block [`ethers::types::block`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/block.rs) `->` [`alloy::rpc::types::eth::block`](https://github.com/alloy-rs/alloy/blob/main/crates/rpc-types/src/eth/block.rs)

<!--

[`alloy::rpc::eth`]()
[`alloy::rpc::types::*`]()

https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types
https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-anvil
https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-engine
https://github.com/alloy-rs/alloy/tree/main/crates/rpc-types-trace
https://github.com/alloy-rs/core/tree/main/crates/sol-types
https://github.com/alloy-rs/core/tree/main/crates/primitives

### Bindings

https://github.com/alloy-rs/core/tree/main/crates/sol-macro-input
https://github.com/alloy-rs/core/tree/main/crates/sol-macro
https://github.com/alloy-rs/core/tree/main/crates/sol-type-parser
https://github.com/alloy-rs/core/tree/main/crates/syn-solidity

### ABI

// https://github.com/gakonst/ethers-rs/issues/2667#issue-1982077921

// TODO:
// - abigen
// - sol! macro
// 
-->