## Setting up a Provider

A [`Provider`](https://alloy-rs.github.io/alloy/alloy_provider/provider/trait/trait.Provider.html) is an abstraction of a connection to the Ethereum network, providing a concise, consistent interface to standard Ethereum node functionality.

### Builder

The correct way of creating a [`Provider`](https://alloy-rs.github.io/alloy/alloy_provider/provider/trait/trait.Provider.html) is through the [`ProviderBuilder`](https://alloy-rs.github.io/alloy/alloy_provider/builder/struct.ProviderBuilder.html), a [builder](https://rust-unofficial.github.io/patterns/patterns/creational/builder.html).

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

### Fillers

[Fillers](https://alloy-rs.github.io/alloy/alloy_provider/fillers/index.html) decorate a [`Provider`](https://alloy-rs.github.io/alloy/alloy_provider/provider/trait/trait.Provider.html), filling transaction details before they are sent to the network. Fillers are used to set the nonce, gas price, gas limit, and other transaction details, and are called before any other layer.

```rust,ignore
//! Example of using the `.with_recommended_fillers()` method in the provider.

use alloy::{
    network::EthereumSigner, node_bindings::Anvil, providers::ProviderBuilder,
    signers::wallet::LocalWallet,
};
use eyre::Result;

#[tokio::main]
async fn main() -> Result<()> {
    // Spin up a local Anvil node.
    // Ensure `anvil` is available in $PATH.
    let anvil = Anvil::new().try_spawn()?;

    // Set up signer from the first default Anvil account (Alice).
    let signer: LocalWallet = anvil.keys()[0].clone().into();

    // Create a provider with the signer.
    let rpc_url = anvil.endpoint().parse()?;
    let provider = ProviderBuilder::new()
        // Adds the `ChainIdFiller`, `GasFiller` and the `NonceFiller` layers.
        .with_recommended_fillers()
        .signer(EthereumSigner::from(signer))
        .on_http(rpc_url);

    // ...

    Ok(())
}

```
