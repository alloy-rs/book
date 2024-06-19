## IPC `Provider`

The [IPC (Inter-Process Communication)](https://en.wikipedia.org/wiki/Inter-process_communication) transport allows our program to communicate with a node over a local [Unix domain socket](https://en.wikipedia.org/wiki/Unix_domain_socket) or [Windows named pipe](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipes).

Using the IPC transport allows the ethers library to send JSON-RPC requests to the Ethereum client and receive responses, without the need for a network connection or HTTP server. This can be useful for interacting with a local Ethereum node that is running on the same network. Using IPC [is faster than RPC](https://github.com/0xKitsune/geth-ipc-rpc-bench), however you will need to have a local node that you can connect to.

### Initializing an `Ipc` Provider

The recommended way of initializing an `Ipc` provider is by using the [`on_ipc`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.on_ipc) method on the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html) with an [`IpcConnect`](https://docs.rs/alloy/latest/alloy/providers/struct.IpcConnect.html) configuration.

```rust,ignore
//! Example of creating an IPC provider using the `on_ipc` method on the `ProviderBuilder`.

use alloy::providers::{IpcConnect, Provider, ProviderBuilder};
use eyre::Result;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Set up the IPC transport which is consumed by the RPC client.
    let ipc_path = "/tmp/reth.ipc";

    // Create the provider.
    let ipc = IpcConnect::new(ipc_path.to_string());
    let provider = ProviderBuilder::new().on_ipc(ipc).await?;

    Ok(())
}
```

An alternative way of initializing is to use the [`on_builtin`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.on_builtin) method on the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html). This method will automatically determine the connection type (`Http`, `Ws` or `Ipc`) depending on the format of the URL. This method is particularly useful if you need a boxed transport.

```rust,ignore
//! Example of creating an IPC provider using the `on_builtin` method on the `ProviderBuilder`.

use alloy::providers::{Provider, ProviderBuilder};
use eyre::Result;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Create a provider with the IPC transport.
    let provider = ProviderBuilder::new().on_builtin("/tmp/reth.ipc").await?;

    Ok(())
}
```

{{#include ../../examples/providers/ipc.md}}