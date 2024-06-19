## Setting up a `Provider`

A [`Provider`](https://docs.rs/alloy/latest/alloy/providers/trait.Provider.html) is an abstraction of a connection to the Ethereum network, providing a concise, consistent interface to standard Ethereum node functionality.

### Builder

The correct way of creating a [`Provider`](https://docs.rs/alloy/latest/alloy/providers/trait.Provider.html) is through the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html), a [builder](https://rust-unofficial.github.io/patterns/patterns/creational/builder.html).

Alloy provides concrete transport implementations for [`HTTP`](./http-provider.md), [`WS` (WebSockets)](./ws-provider.md) and [`IPC` (Inter-Process Communication)](./ipc-provider.md), as well as higher level transports which wrap a single or multiple transports.

```rust,ignore
//! Example of using the HTTP provider using the `on_http` method.

use alloy::providers::{Provider, ProviderBuilder};
use eyre::Result;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Set up the HTTP transport which is consumed by the RPC client.
    let rpc_url = "https://eth.merkle.io".parse()?;

    // Create a provider with the HTTP transport using the `reqwest` crate.
    let provider = ProviderBuilder::new().on_http(rpc_url);

    Ok(())
}
```

Next, lets look at the [HTTP Provider](./http-provider.md).