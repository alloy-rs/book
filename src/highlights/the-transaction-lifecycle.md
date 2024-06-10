## The transaction lifecycle

Let us walk through the process of creating a transaction to send `100 wei` from `Alice` to `Bob`, signing the transaction and broadcasting the signed transaction to the Ethereum network.

Expressing our intent as a [`TransactionRequest`](https://alloy-rs.github.io/alloy/alloy/rpc/types/eth/struct.TransactionRequest.html):

```rust,ignore
    // Build a transaction to send 100 wei from Alice to Bob.
    let tx = TransactionRequest::default()
        .with_from(alice)
        .with_to(bob)
        .with_nonce(nonce)
        .with_chain_id(chain_id)
        .with_value(U256::from(100))
        .with_gas_price(gas_price)
        .with_gas_limit(gas_limit);
```

### Setup

First let's set up our environment:

We start by defining the RPC URL of our local Ethereum node [Anvil](https://github.com/foundry-rs/foundry/tree/master/crates/anvil) node.
If you do not have `Anvil` installed see the [Foundry](https://github.com/foundry-rs/foundry) [installation instructions](https://book.getfoundry.sh/getting-started/installation).

```rust,ignore
    // Spin up a local Anvil node.
    // Ensure `anvil` is available in $PATH.
    let anvil = Anvil::new().try_spawn()?;

    // Create a provider with a signer and the network.
    let rpc_url = anvil.endpoint().parse()?;
```

```rust,ignore
    // Alternatively you can use any valid RPC URL found on https://chainlist.org/
    let rpc_url = "https://eth.merkle.io".parse()?;
```

Next let's define a `signer` for Alice. By default `Anvil` defines a mnemonic phrase: `"test test test test test test test test test test test junk"`. Make sure to not use this mnemonic phrase outside of testing environments.

Let's derive the first key of the mnemonic phrase for `Alice`.

```rust,ignore
    // Set up wallet from the first default Anvil account (Alice).
    let wallet: LocalWallet = anvil.keys()[0].clone().into();
```

Next lets grab the address of our users `Alice` and `Bob`.

```rust,ignore
    // Create two users, Alice and Bob.
    let alice = wallet.address();
    let bob = anvil.addresses()[1];
```

Next we can build the `Provider` using the `ProviderBuilder`.

Note that we use `.with_recommended_fillers()` method on the [ProviderBuilder](../building-with-alloy/connecting-to-a-blockchain/setting-up-a-provider.md) to automatically [fill fields](../building-with-alloy/understanding-fillers.md). 

```rust,ignore
    let provider = ProviderBuilder::new()
        .with_recommended_fillers()
        .signer(EthereumSigner::from(wallet))
        .on_http(rpc_url);
```

Let's modify our original `TransactionRequest` to make use of the [RecommendedFillers](https://alloy-rs.github.io/alloy/alloy/providers/fillers/type.RecommendedFiller.html) installed on the `Provider` to automatically fill out transaction details.

The `RecommendedFillers` includes the following fillers:

- [GasFiller](https://alloy-rs.github.io/alloy/alloy/providers/fillers/struct.GasFiller.html)
- [NonceFiller](https://alloy-rs.github.io/alloy/alloy/providers/fillers/struct.NonceFiller.html)
- [ChainIdFiller](https://alloy-rs.github.io/alloy/alloy/providers/fillers/struct.ChainIdFiller.html)

### Building the transaction

Because of we are using `RecommendedFillers` our `TransactionRequest` we only need a subset of the original fields:

```diff
    // Build a transaction to send 100 wei from Alice to Bob.
    let tx = TransactionRequest::default()
        .with_from(alice)
        .with_to(bob)
-       .with_nonce(nonce)
-       .with_chain_id(chain_id)
        .with_value(U256::from(100))
-       .with_gas_price(gas_price)
-       .with_gas_limit(gas_limit);
```

```rust,ignore
    // Build a transaction to send 100 wei from Alice to Bob.
    let tx = TransactionRequest::default()
        .with_from(alice)
        .with_to(bob)
        .with_value(U256::from(100));
```

Much better!

### Signing and broadcasting the transaction

Given that we have configured a signer on our `Provider` we can sign the transaction locally and broadcast in a single line:

There are three ways to listen for transaction inclusion after broadcasting the transaction, depending on your requirements:

```rust,ignore
    // Send the transaction and listen for the transaction to be broadcasted.
    let pending_tx = provider.send_transaction(tx).await?.register().await?;
```

```rust,ignore
    // Send the transaction and listen for the transaction to be included.
    let tx_hash = provider.send_transaction(tx).await?.watch().await?;
```

```rust,ignore
    // Send the transaction and fetch the receipt after the transaction was included.
    let tx_receipt = provider.send_transaction(tx).await?.get_receipt().await?;
```
