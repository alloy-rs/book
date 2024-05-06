## Setting up a Provider

A [Provider](https://alloy-rs.github.io/alloy/alloy_provider/provider/trait/trait.Provider.html) is an abstraction of a connection to the Ethereum network, providing a concise, consistent interface to standard Ethereum node functionality. The correct way of instantiating a `Provider` is to use [`ProviderBuilder`](https://alloy-rs.github.io/alloy/alloy_provider/builder/struct.ProviderBuilder.html).

## Transports

Alloy provides concrete transport implementations for [HTTP](./http-provider.md), [WS (WebSockets)](./ws-provider.md) and [IPC (Inter-Process Communication)](./ipc-provider.md), as well as higher level transports which wrap a single or multiple transports.
