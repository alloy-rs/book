## Multicall and Multicall Batching layer

Alloy provides two ways in which a user can make multicalls to the [Multicall3 contract](https://www.multicall3.com/), both of which tightly integrated with the `Provider` to make usage as easy as possible.

### Multicall Builder

Accessed via the `provider.multicall()` method works hand in hand with the bindings returned by the `sol!` macro to stack up multiple calls.

```rust,ignore
let multicall = provider
        .multicall()
        // Set the address of the Multicall3 contract. If unset it uses the default address from <https://github.com/mds1/multicall>: 0xcA11bde05977b3631167028862bE2a173976CA11
        // .address(multicall3)
        // Get the total supply of WETH on our anvil fork.
        .add(weth.totalSupply())
        // Get Alice's WETH balance.
        .add(weth.balanceOf(alice))
        // Also fetch Alice's ETH balance.
        .get_eth_balance(alice);
```

You can find the complete example [here](https://github.com/alloy-rs/examples/blob/main/examples/providers/examples/multicall.rs)

### Multicall Batching Layer

Append a batching layer to the provider enabling `EthCall`'s to be automatically aggregated under the hood.

This layer is useful for reducing the number of network requests made.
However, this only works when requests are made in parallel, for example when using the
[`tokio::join!`] macro or in multiple threads/tasks, as otherwise the requests will be sent one
by one as normal, but with an added delay.

```rust,ignore
use alloy_provider::{layers::CallBatchLayer, Provider, ProviderBuilder};
use std::time::Duration;

async fn f(url: &str) -> Result<(), Box<dyn std::error::Error>> {
    // Build a provider with the default call batching configuration.
    let provider = ProviderBuilder::new().with_call_batching().connect(url).await?;

    // Build a provider with a custom call batching configuration.
    let provider = ProviderBuilder::new()
        .layer(CallBatchLayer::new().wait(Duration::from_millis(10)))
        .connect(url)
        .await?;

    // Both of these requests will be batched together and only 1 network request will be made.
    let (block_number_result, chain_id_result) =
        tokio::join!(provider.get_block_number(), provider.get_chain_id());
    let block_number = block_number_result?;
    let chain_id = chain_id_result?;
    println!("block number: {block_number}, chain id: {chain_id}");
    Ok(())
}
```
