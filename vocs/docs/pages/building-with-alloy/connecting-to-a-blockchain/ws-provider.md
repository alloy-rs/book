## WS Provider

The `Ws` provider establishes an WebSocket connection with a node, allowing you to send JSON-RPC requests to the node to fetch data, simulate calls, send transactions and much more. The `Ws` provider can be used with any Ethereum node that supports WebSocket connections. This allows programs to interact with the network in real-time without the need for HTTP polling for things like new block headers and filter logs.

### Initializing a `Ws` Provider

The recommended way of initializing a `Ws` provider is by using the [`connect_ws`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html#method.connect_ws) method on the [`ProviderBuilder`](https://docs.rs/alloy/latest/alloy/providers/struct.ProviderBuilder.html) with a [`WsConnect`](https://docs.rs/alloy/latest/alloy/providers/struct.WsConnect.html) configuration.

```rust
//! Example of creating an WS provider using the `connect_ws` method on the `ProviderBuilder`.

use alloy::providers::{Provider, ProviderBuilder, WsConnect};
use eyre::Result;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Set up the WS transport which is consumed by the RPC client.
    let rpc_url = "wss://eth-mainnet.g.alchemy.com/v2/your-api-key";

    // Create the provider.
    let ws = WsConnect::new(rpc_url);
    let provider = ProviderBuilder::new().connect_ws(ws).await?;

    Ok(())
}
```

Similar to the other providers, you can also establish an authorized connection with a node via websockets.

{{#include ../../examples/providers/ws.md}}

{{#include ../../examples/providers/ws_with_auth.md}}
