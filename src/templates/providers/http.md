### Http

The `Http` provider establishes an HTTP connection with a node, allowing you to send RPC requests to the node to fetch data, simulate calls, send transactions and much more.

#### Initializing an Http Provider

Lets take a quick look at few ways to create a new `Http` provider. The recommended way of initializing a `Http` provider is by using the [on_http](https://alloy-rs.github.io/alloy/alloy_provider/builder/struct.ProviderBuilder.html#method.on_http) method on the [ProviderBuilder](https://alloy-rs.github.io/alloy/alloy_provider/builder/struct.ProviderBuilder.html).

```rust,ignore
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

An alternative way of initializing is to use the [on_builtin](https://alloy-rs.github.io/alloy/alloy_provider/builder/struct.ProviderBuilder.html#method.on_builtin) method on the [ProviderBuilder](https://alloy-rs.github.io/alloy/alloy_provider/builder/struct.ProviderBuilder.html). This method will automatically determine the connection type (`Http`, `Ws` or `Ipc`) depending on the format of the URL. This method is particularly useful if you need a boxed transport.

```rust,ignore
use alloy::providers::{Provider, ProviderBuilder};
use eyre::Result;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Create a provider with the HTTP transport using the `reqwest` crate.
    let provider = ProviderBuilder::new().on_builtin("https://eth.merkle.io").await?;
}
```