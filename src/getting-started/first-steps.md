## First steps

Alloy allows applications to connect the blockchain using providers. Providers act as an interface between applications and an Ethereum node, allowing you to send requests and receive responses via JSON-RPC messages.

Some common actions you can perform using a provider include:

- Getting the current block number
- Getting the balance of an Ethereum address
- Sending a transaction to the blockchain
- Calling a smart contract function
- Subscribe logs and smart contract events
- Getting the transaction history of an address

After [installing](./installation.md) `alloy` let's create an example of using the HTTP provider and fetching the latest block number.

Install [`tokio`](https://crates.io/crates/tokio) and [`eyre`](https://crates.io/crates/eyre) as dependencies and define the body as follows:

```rust,ignore
//! Example of creating an HTTP provider using the `on_http` method on the `ProviderBuilder`.

use alloy::providers::{Provider, ProviderBuilder};
use eyre::Result;

#[tokio::main]
async fn main() -> Result<()> {
    // ...

    Ok(())
}
```

Next, add the following section to the body to create a provider with HTTP transport:

```rust,ignore
// Set up the HTTP transport which is consumed by the RPC client.
let rpc_url = "https://eth.merkle.io".parse()?;

// Create a provider with the HTTP transport using the `reqwest` crate.
let provider = ProviderBuilder::new().on_http(rpc_url);
```

Finally we fetch the latest block number using the provider:

```rust,ignore
// Get latest block number.
let latest_block = provider.get_block_number().await?;

// Print the block number.
println!("Latest block number: {latest_block}");
```

The complete and runnable example can be found [here](https://github.com/alloy-rs/examples/blob/main/examples/providers/examples/http.rs), one of the [many runnable examples of Alloy](https://github.com/alloy-rs/examples/blob/main/README.md#overview) to explore.
