# Wrapping a Provider

A common pattern is to create abstractions over the `Provider` type to add additional functionality or to bake in a more
user-friendly API on top. The goal of this is to have the more verbose part API or error handling done under the hood.

For example, creating a `Deployer` struct that ingests the `Provider` and the bytecode to deploy contracts and interact with them. More on this in the example snippets below.

There are multiple ways in which a provider can be wrapped:

1. Using the `P: Provider`.
2. Wrapping the `DynProvider` when you're okay with erasing the type information.

## Using generics `P: Provider`

The ideal way is by using the `P: Provider` generic on the encapsulating type. This is depicted by the following [example](/examples/providers/wrapped_provider).

```rust [wrapped_provider.rs]
// [!include ~/snippets/providers/examples/wrapped_provider.rs]
```

## DynProvider

Sometimes, you're okay with type erasure and don't want to use generics. In those cases, one should use the `DynProvider`.

[`DynProvider`](/examples/providers/dyn_provider) erases the type of a provider while maintaining its core functionality.

```rust [dyn_provider.rs]
// [!include ~/snippets/providers/examples/dyn_provider.rs]
```

One might be tempted to `Arc` a `Provider` to enable `Clone` on the struct.

```rust
#[derive(Clone)]
struct MyProvider<P: Provider> {
    inner: Arc<P>, // Not required
}
```

However, this is not required as the inner provider is already `Arc`-ed, and one should just add the `Clone` bound to the `Provider` when needed.

```rust
struct MyProvider<P: Provider + Clone> {
    inner: P,
}
```
