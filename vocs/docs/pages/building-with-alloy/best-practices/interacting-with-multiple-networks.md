## Interacting with multiple networks

The provider trait is generic over the network type, `Provider<N: Network = Ethereum>`, with the default network set to `Ethereum`.

The `Network` generic helps the provider to accomodate various network types with different transaction and RPC response types seamlessly.

This removes the need for implementing the `Provider` trait for each network type you want to interact with. Instead, we just need to implement the `Network` trait.

Following is the [`Ethereum` network implementation](https://github.com/alloy-rs/alloy/blob/main/crates/network/src/ethereum/mod.rs) which defines the structure of the network and its RPC types.

```rust,ignore
impl Network for Ethereum {
    type TxType = alloy_consensus::TxType;

    type TxEnvelope = alloy_consensus::TxEnvelope;

    type UnsignedTx = alloy_consensus::TypedTransaction;

    type ReceiptEnvelope = alloy_consensus::ReceiptEnvelope;

    type Header = alloy_consensus::Header;

    type TransactionRequest = alloy_rpc_types_eth::transaction::TransactionRequest;

    type TransactionResponse = alloy_rpc_types_eth::Transaction;

    type ReceiptResponse = alloy_rpc_types_eth::TransactionReceipt;

    type HeaderResponse = alloy_rpc_types_eth::Header;

    type BlockResponse = alloy_rpc_types_eth::Block;
}
```

The `Provider` defaults to the ethereum network type, but one can easily switch to another network while building the provider like so:

```rust,ignore
let provider = ProviderBuilder::new()
    .network::<AnyNetwork>()
    .connect_http("http://localhost:8545");
```

The [`AnyNetwork` type](https://github.com/alloy-rs/alloy/blob/main/crates/network/src/any/mod.rs) is a catch-all network allowing you to interact with any network type, in case you don't want to roll your own network type.

The [`Optimism` network](https://github.com/alloy-rs/op-alloy/blob/main/crates/network/src/lib.rs) type has been created to interact with OP-stack chains such as Base.

```rust,ignore
let provider = ProviderBuilder::new()
    .network::<op_alloy_network::Optimism>()
    .connect_http("http://localhost:8545");
```
