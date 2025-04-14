# Building a High-Priority Transaction Queue with Alloy Fillers

In this guide, we will explore more advanced use cases of Alloy Providers APIs. We will cover non-standard ways to instantiate and customize providers and deep dive into custom layers and fillers implementations. We have a lot to cover, so let's get started!

## Fillers

Fillers decorate a Provider, and hook into the transaction lifecycle filling details before they are sent to the network. We can use fillers to build a transaction preprocessing pipeline, "filling" all the missing properties such as `nonce`, `chain_id`, `max_fee_per_gas`, and `max_priority_fee_per_gas` etc.

Since, [alloy `v0.11.0`](https://github.com/alloy-rs/alloy/releases/tag/v0.11.0) the most essential fillers are enabled by default when building a provider using `ProviderBuilder::new()`.
These core fillers are termed as [`RecommendedFillers`](https://docs.rs/alloy-provider/latest/alloy_provider/fillers/type.RecommendedFiller.html) and consists of the following:

- [`NonceFiller`](https://docs.rs/alloy-provider/latest/alloy_provider/fillers/struct.NonceFiller.html): Fills the `nonce` field of a transaction with the next available nonce.
- [`ChainIdFiller`](https://docs.rs/alloy-provider/latest/alloy_provider/fillers/struct.ChainIdFiller.html): Fills the `chain_id` field of a transaction with the chain ID of the provider.
- [`GasFiller`](https://docs.rs/alloy-provider/latest/alloy_provider/fillers/struct.GasFiller.html): Fills the gas related fields such as `gas_price`, `gas_limit`, `max_fee_per_gas` and `max_priority_fee_per_gas` fields of a transaction with the current gas price.
- [`BlobGasFiller`](https://docs.rs/alloy-provider/latest/alloy_provider/fillers/struct.BlobGasFiller.html): Fills the `max_fee_per_blob_gas` field for EIP-4844 transactions.

In a world without the above fillers, sending a simple transfer transaction looks like the following:

[ `examples/basic.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/fillers/examples/basic.rs)

```rust
#[tokio::main]
async fn main() -> Result<()> {
    let anvil = Anvil::new().try_spawn()?;
    let signer: PrivateKeySigner = anvil.keys()[0].clone().into();
    let alice = signer.address();

    let provider = ProviderBuilder::new()
        .disable_recommended_fillers()
        .wallet(wallet)
        .on_http(anvil.endpoint().parse()?);

    let alice = signer.address();
    let bob = Address::from([0x42; 20]);
    let fees = provider.estimate_eip1559_fees().await?;
    let nonce = provider.get_transaction_count(alice).await?;
    let chain_id = provider.get_chain_id().await?;

    let tx = TransactionRequest::default()
        .with_value(U256::from(1))
        .with_chain_id(chain_id)
        .with_from(alice)
        .with_nonce(nonce)
        .with_max_fee_per_gas(fees.max_fee_per_gas)
        .with_max_priority_fee_per_gas(fees.max_priority_fee_per_gas)
        .with_gas_limit(21000)
        .with_to(bob)
        .with_value(U256::from(1));

    let bob_balance_before = provider.get_balance(bob).await?;
    _ = provider.send_transaction(tx).await?.get_receipt().await?;
    let bob_balance_after = provider.get_balance(bob).await?;
    println!(
        "Balance before: {}\nBalance after: {}",
        bob_balance_before, bob_balance_after
    );

    Ok(())
}
```

Running the above produces:

```text
Balance before: 0
Balance after: 1
```

In this example, we sent 1 wei from `alice` (default anvil account) to `bob`. You can see that a lot of boilerplate is involved in building the transaction data. We must manually check the account's current `nonce`, network fees, `gas_limit`, and `chain_id`.

If we omitted any of the transaction properties we'd see an error like:

```text
Caused by:
    missing properties: [("Wallet", ["nonce", "gas_limit", "max_fee_per_gas", "max_priority_fee_per_gas"])]
```

Now, let's see how using `RecommendedFillers` improves this:

[ `examples/recommended.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/fillers/examples/recommended.rs)

```rust
#[tokio::main]
async fn main() -> Result<()> {
    let provider = ProviderBuilder::new().on_anvil_with_wallet();
    let bob = Address::from([0x42; 20]);
    let tx = TransactionRequest::default()
        .with_to(bob)
        .with_value(U256::from(1));

    let bob_balance_before = provider.get_balance(bob).await?;
    _ = provider.send_transaction(tx).await?.get_receipt().await?;
    let bob_balance_after = provider.get_balance(bob).await?;
    println!(
        "Balance before: {}\nBalance after: {}",
        bob_balance_before, bob_balance_after
    );

    Ok(())
}
```

We've removed ~15 LOC while preserving the same functionality! Most heavy lifting was taken over by recommended fillers that are enabled upon `ProviderBuilder::new()` and the `on_anvil_with_wallet` method.

`on_anvil_with_wallet` is a helper method that implicitly spawns the Anvil process and enables the [`WalletFiller`](https://docs.rs/alloy/latest/alloy/providers/fillers/struct.WalletFiller.html) that sets the `from` field based on the wallet's signer address and signs the transaction.

This explains why we could omit filling out `nonce`, `chain_id`, `max_fee_per_gas` and `max_priority_fee_per_gas` in the second example.

In case you want you want to disable the default fillers you can do so by calling [`disable_recommended_fillers()`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.disable_recommended_fillers) on the `ProviderBuilder`, and setting the fillers of your choice manually.

Alloy comes with builder methods for automatically applying fillers to providers:

- [ `wallet`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.wallet) - set `from` based on the wallet's signer address
- [ `fetch_chain_id`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.fetch_chain_id) - automatically set `chain_id` based on data from the provider
- [ `with_chain_id`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.with_chain_id) - automatically set `chain_id` based on provided value
- [ `with_simple_nonce_management`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.with_simple_nonce_management) - set `nonce` based on txs count from provider
- [ `with_cached_nonce_management`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.with_cached_nonce_management) - like above but with caching
- [ `with_nonce_management`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.with_nonce_management) - provided custom `nonce` management strategy
- [ `with_gas_estimation`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.with_gas_estimation) - set gas prices based on data from the provider

Let's go beyond the basics and implement a custom filler to better understand the inner workings.

## Implementing a custom Alloy filler

Submitting txs with a high-enough gas price, to land in the next block is a common use case. We will implement a custom filler to automatically check and fill the correct gas price.

We will query the free [Blocknative Gas API](https://docs.blocknative.com/gas-prediction/gas-platform) to check the recommended gas price, and land our payload in the next block.

We will be working with the following API output:

```bash
curl https://api.blocknative.com/gasprices/blockprices
```

```json
{
  "system": "ethereum",
  "network": "main",
  "unit": "gwei",
  "maxPrice": 172.0,
  "currentBlockNumber": 21465702,
  "msSinceLastBlock": 14416,
  "blockPrices": [
    {
      "blockNumber": 21465703,
      "estimatedTransactionCount": 67,
      "baseFeePerGas": 36.23398572,
      "blobBaseFeePerGas": 25.17758517,
      "estimatedPrices": [
        {
          "confidence": 99,
          "price": 36.53,
          "maxPriorityFeePerGas": 0.29,
          "maxFeePerGas": 72.76
        },
        {
          "confidence": 95,
          "price": 36.3,
          "maxPriorityFeePerGas": 0.062,
          "maxFeePerGas": 72.53
        },
        {
          "confidence": 90,
          "price": 36.29,
          "maxPriorityFeePerGas": 0.057,
          "maxFeePerGas": 72.52
        },
        {
          "confidence": 80,
          "price": 36.28,
          "maxPriorityFeePerGas": 0.047,
          "maxFeePerGas": 72.51
        },
        {
          "confidence": 70,
          "price": 36.27,
          "maxPriorityFeePerGas": 0.037,
          "maxFeePerGas": 72.5
        }
      ]
    }
  ]
}
```

It shows gas prices needed to commit tx in the next block, with a specified confidence.

To build a custom filler, you have to implement a [`TxFiller`](https://docs.rs/alloy-provider/latest/alloy_provider/fillers/trait.TxFiller.html) trait. Here's a sample implementation for our `UrgentQueue` filler:

[`src/lib.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/fillers/src/lib.rs)

```rust
#[derive(Clone, Debug, Default)]
pub struct UrgentQueue {
    client: Client,
}

impl UrgentQueue {
    pub fn new() -> Self {
        Self {
            client: Client::new(),
        }
    }
}

#[derive(Debug)]
pub struct GasPriceFillable {
    max_fee_per_gas: u128,
    max_priority_fee_per_gas: u128,
}

impl<N: Network> TxFiller<N> for UrgentQueue {
    type Fillable = GasPriceFillable;

    fn status(&self, tx: &<N as Network>::TransactionRequest) -> FillerControlFlow {
        if tx.max_fee_per_gas().is_some() && tx.max_priority_fee_per_gas().is_some() {
            FillerControlFlow::Finished
        } else {
            FillerControlFlow::Ready
        }
    }
    fn fill_sync(&self, _tx: &mut SendableTx<N>) {}

    async fn fill(
        &self,
        fillable: Self::Fillable,
        mut tx: SendableTx<N>,
    ) -> TransportResult<SendableTx<N>> {
        if let Some(builder) = tx.as_mut_builder() {
            builder.set_max_fee_per_gas(fillable.max_fee_per_gas);
            builder.set_max_priority_fee_per_gas(fillable.max_priority_fee_per_gas);
        } else {
            panic!("Expected a builder");
        }

        Ok(tx)
    }

    async fn prepare<P, T>(
        &self,
        _provider: &P,
        _tx: &<N as Network>::TransactionRequest,
    ) -> TransportResult<Self::Fillable>
    where
        P: Provider<T, N>,
        T: Transport + Clone,
    {
        let data = match self
            .client
            .get("https://api.blocknative.com/gasprices/blockprices")
            .send()
            .await
        {
            Ok(res) => res,
            Err(e) => {
                return Err(RpcError::Transport(TransportErrorKind::Custom(Box::new(
                    std::io::Error::new(
                        std::io::ErrorKind::Other,
                        format!("Failed to fetch gas price, {}", e),
                    ),
                ))));
            }
        };
        let body = data.text().await.unwrap();
        let json = serde_json::from_str::<serde_json::Value>(&body).unwrap();
        let prices = &json["blockPrices"][0]["estimatedPrices"][0];
        let max_fee_per_gas = (prices["maxFeePerGas"].as_f64().unwrap() * 1e9) as u128;
        let max_priority_fee_per_gas =
            (prices["maxPriorityFeePerGas"].as_f64().unwrap() * 1e9) as u128;

        let fillable = GasPriceFillable {
            max_fee_per_gas,
            max_priority_fee_per_gas,
        };
        Ok(fillable)
    }
}
```

The above implementation fetches gas prices from the Blocknative API and injects them into our transaction. With this implementation, we'll have 99% confidence that our transaction will land in the next block. Here's how you can use it:

[ `examples/urgent.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/fillers/examples/urgent.rs)

```rust
let provider = ProviderBuilder::new()
    .filler(UrgentQueue::default())
    .on_anvil_with_wallet();
```

The rest of the example remains the same. It shows a great feature of fillers, i.e. composability. They are processed in reverse order, meaning that our `UrgentQueue` filler will take precedence over the built-in `GasFiller`.

## Summary

Fillers are helpful in reworking txs submission logic, depending on any custom conditions. The presented `UrgentQueue` implementation is relatively basic, but should serve you as a starting point for building your custom fillers.