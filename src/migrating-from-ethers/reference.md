## Reference

[ethers-rs](https://github.com/gakonst/ethers-rs/) has been deprecated in favor of [Alloy](https://github.com/alloy-rs/) and [Foundry](https://github.com/foundry-rs/).

The following is a reference guide for finding the migration path for your specific crate, dependency or information source.

### Documentation

- Book: [`ethers-rs/book`](https://github.com/gakonst/ethers-rs/tree/master/book) `->` [`alloy-rs/book`](https://github.com/alloy-rs/book)

### Examples

- Examples: [`ethers-rs/examples`](https://github.com/gakonst/ethers-rs/tree/master/examples) `->` [`alloy-rs/examples`](https://github.com/alloy-rs/examples)

### Alloy

- Meta-crate: [`ethers`](https://github.com/gakonst/ethers-rs/tree/master/ethers) `->` [`alloy`](https://github.com/alloy-rs/alloy/tree/main/crates/alloy)
- Contract: [`ethers::contract`](https://github.com/gakonst/ethers-rs/tree/master/ethers-contract) `->` [`alloy::contract`](https://github.com/alloy-rs/alloy/tree/main/crates/contract)
- Core: [`ethers::core`](https://github.com/gakonst/ethers-rs/tree/master/ethers-core) `->` [`alloy::core`](https://github.com/alloy-rs/core)
  - Chains: [`ethers::core::types::Chain`](https://github.com/gakonst/ethers-rs/blob/master/ethers-core/src/types/chain.rs) `->` [`alloy-rs/chains`](https://github.com/alloy-rs/chains)
- Middleware [`ethers::middleware`](https://github.com/gakonst/ethers-rs/tree/master/ethers-middleware) `->` Fillers [`alloy::provider::{fillers, layers}`](https://github.com/alloy-rs/alloy/tree/main/crates/provider/src)
  - Gas oracle [`ethers::middleware::GasOracleMiddleware`](https://github.com/gakonst/ethers-rs/blob/master/ethers-middleware/src/gas_oracle/middleware.rs) `->` Gas filler [`alloy::provider::GasFiller`](https://github.com/alloy-rs/examples/blob/main/examples/fillers/examples/gas_filler.rs)
  - Nonce manager [`ethers::middleware::NonceManagerMiddleware`](https://github.com/gakonst/ethers-rs/tree/master/ethers-middleware/src/nonce_manager.rs) `->` Nonce filler [`alloy::provider::NonceFiller`](https://github.com/alloy-rs/alloy/tree/main/crates/provider/src/fillers/nonce.rs)
- Providers [`ethers::providers`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers) `->` Provider [`alloy-provider`](https://github.com/alloy-rs/alloy/tree/main/crates/provider)
- Transports [`ethers::providers`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports) `->` Transport [`alloy-transport`](https://github.com/alloy-rs/alloy/tree/main/crates/transport)
  - HTTP [`ethers::providers::Http`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports/http.rs) `->` [`alloy-transport-http`](https://github.com/alloy-rs/alloy/tree/main/crates/transport-http)
  - IPC [`ethers::providers`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports/ipc.rs) `->` [`alloy-transport-ipc`](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ipc)
  - WS [`ethers::providers`](https://github.com/gakonst/ethers-rs/tree/master/ethers-providers/src/rpc/transports/ws) `->` [`alloy-transport-ws`](https://github.com/alloy-rs/alloy/tree/main/crates/transport-ws)
- Signers [`ethers::signers`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers) `->` Signer [`alloy-signer`](https://github.com/alloy-rs/alloy/tree/main/crates/signer)
  - AWS [`ethers::signers::aws`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/aws) `->` [`alloy-signer-aws`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-aws)
  - GCP `x` `->` [`alloy-signer-gcp`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-gcp)
  - Ledger [`ethers::signers::ledger`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/ledger) `->` [`alloy-signer-ledger`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-ledger)
  - Trezor [`ethers::signers::trezor`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/trezor) `->` [`alloy-signer-trezor`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-trezor)
  - Wallet [`ethers::signers::wallet`](https://github.com/gakonst/ethers-rs/tree/master/ethers-signers/src/wallet) `->` [`alloy-signer-wallet`](https://github.com/alloy-rs/alloy/tree/main/crates/signer-wallet)

### Others

- Address book: [`ethers::addressbook`](https://github.com/gakonst/ethers-rs/tree/master/ethers-addressbook) `->` Not planned
- Etherscan [`ethers::etherscan`](https://github.com/gakonst/ethers-rs/tree/master/ethers-etherscan) `->` [`foundry-block-explorers`](https://github.com/foundry-rs/block-explorers)
- Compilers [`ethers::solc`](https://github.com/gakonst/ethers-rs/tree/master/ethers-solc) `->` [`foundry-compilers`](https://github.com/foundry-rs/compilers)

### Types

<!-- 
// https://github.com/gakonst/ethers-rs/issues/2667#issue-1982077921
-->

