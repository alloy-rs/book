## Setting up a Provider

A [`Provider`](https://docs.rs/alloy/latest/alloy/providers/trait.Provider.html) is an abstraction of a connection to the Ethereum network, providing a concise, consistent interface to standard Ethereum node functionality.

### Builder

The correct way of creating a [`Provider`](https://docs.rs/alloy/latest/alloy/providers/trait.Provider.html) is through the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html), a [builder](https://rust-unofficial.github.io/patterns/patterns/creational/builder.html).

Alloy provides concrete transport implementations for [`HTTP`](./http-provider.md), [`WS` (WebSockets)](./ws-provider.md) and [`IPC` (Inter-Process Communication)](./ipc-provider.md), as well as higher level transports which wrap a single or multiple transports.

The [`connect`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.connect) method on the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html) will automatically determine the connection type (`Http`, `Ws` or `Ipc`) depending on the format of the URL.

```rust
//! Example of `.connect` to setup a simple provider

use alloy::providers::{Provider, ProviderBuilder};
use eyre::Result;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Set up the RPC URL.
    let rpc_url = "https://eth.merkle.io";

    // Instanties a provider using a rpc_url string.
    let provider = ProviderBuilder::new().connect(rpc_url).await?;

    Ok(())
}
```

Next, lets look at the [HTTP Provider](./http-provider.md).
