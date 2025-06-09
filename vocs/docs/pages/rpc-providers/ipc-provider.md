---
description: Connect to local Ethereum nodes using Inter-Process Communication for optimal performance
---

## IPC Provider

The [IPC (Inter-Process Communication)](https://en.wikipedia.org/wiki/Inter-process_communication) transport allows our program to communicate with a node over a local [Unix domain socket](https://en.wikipedia.org/wiki/Unix_domain_socket) or [Windows named pipe](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipes).

Using the IPC transport allows the ethers library to send JSON-RPC requests to the Ethereum client and receive responses, without the need for a network connection or HTTP server. This can be useful for interacting with a local Ethereum node that is running on the same network. Using IPC [is faster than RPC](https://github.com/0xKitsune/geth-ipc-rpc-bench), however you will need to have a local node that you can connect to.

### Initializing an `Ipc` Provider

The recommended way of initializing an `Ipc` provider is by using the [`connect_ipc`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.connect_ipc) method on the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html) with an [`IpcConnect`](https://docs.rs/alloy/latest/alloy/providers/struct.IpcConnect.html) configuration.

```rust
//! Example of creating an IPC provider using the `connect_ipc` method on the `ProviderBuilder`.

use alloy::providers::{IpcConnect, Provider, ProviderBuilder}; // [!code focus]
use std::error::Error;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    // Set up the IPC transport which is consumed by the RPC client.
    let ipc_path = "/tmp/reth.ipc";

    // Create the provider.
    let ipc = IpcConnect::new(ipc_path.to_string()); // [!code focus]
    let provider = ProviderBuilder::new().connect_ipc(ipc).await?; // [!code focus]

    Ok(())
}
```
