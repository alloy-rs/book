## HTTP `Provider`

The `Http` provider establishes an HTTP connection with a node, allowing you to send JSON-RPC requests to the node to fetch data, simulate calls, send transactions and much more.

### Initializing an Http Provider

The recommended way of initializing a `Http` provider is by using the [`on_http`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.on_http) method on the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html).

```rust,ignore
//! Example of creating an HTTP provider using the `on_http` method on the `ProviderBuilder`.

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

An alternative way of initializing is to use the [`on_builtin`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.on_builtin) method on the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html). This method will automatically determine the connection type (`Http`, `Ws` or `Ipc`) depending on the format of the URL. This method is particularly useful if you need a boxed transport.

```rust,ignore
//! Example of creating an HTTP provider using the `on_builtin` method on the `ProviderBuilder`.

use alloy::providers::{Provider, ProviderBuilder};
use eyre::Result;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Create a provider with the HTTP transport using the `reqwest` crate.
    let provider = ProviderBuilder::new().on_builtin("https://eth.merkle.io").await?;

    Ok(())
}
```

{{#include ../../examples/providers/http.md}}
