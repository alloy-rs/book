---
description: Optimize RPC usage by batching multiple smart contract calls using Multicall Builder and Layer
---

# Multicall and Multicall Batching layer

## What is Multicall?

Multicall is a smart contract and pattern that allows you to batch multiple read-only calls to the Ethereum blockchain into a single request. Instead of sending separate RPC requests, Multicall combines them into one transaction, significantly reducing network overhead and latency. This solves various problems such as reduced latency and rate-limiting, network overhead, atomic state reading & offers better UX.

## When should I use Multicall ?

- To read multiple contract states e.g. fetching balances, allowances, or prices across multiple contracts
- To reduce request count e.g. working with public RPC endpoints that have rate limits
- To ensure data consistency e.g. when you need multiple values from the same blockchain state

Note that Multicall is not suitable for write operations (transactions that change state) and sequential operations where each call depends on the result of the previous one.

## Multicall with Alloy

Alloy provides two ways in which a user can make multicalls to the [Multicall3 contract](https://www.multicall3.com/), both of which tightly integrated with the `Provider` to make usage as easy as possible:

1. Multicall Builder: The `multicall()` method gives you explicit control over which calls to batch
2. Multi-batching Layer: The batching layer automatically batches requests that are made in parallel

### 1. Multicall Builder

Accessed via the `provider.multicall()` method works hand in hand with the bindings returned by the `sol!` macro to stack up multiple calls.

```rust
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

You can find the complete example [here](/examples/providers/multicall)

This approach is suitable when:

- You know exactly which calls you want to batch together
- You need to explicitly collect related data in a single request
- You need fine-grained control over the order of results
- You are working with varied contract types in a single batch

### 2. Multicall Batching Layer

The batching layer is especially powerful because it requires no changes to your existing code and reduces the number of network requests.

However, this only works when requests are made in parallel, for example when using the
[`tokio::join!`] macro or in multiple threads/tasks, as otherwise the requests will be sent one
by one as normal, but with an added delay.

```rust [multicall_batching.rs]
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

Find the complete example [here](/examples/providers/multicall_batching). This approach is suitable when:

- You want to optimize existing code without restructuring it
- You need to batch calls that are made from different parts of your codebase
