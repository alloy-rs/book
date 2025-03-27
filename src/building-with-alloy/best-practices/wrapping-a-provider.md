## Wrapping a Provider

There are multiple ways in which a provider can be wrapped.

1. Using the `P: Provider`.
2. Wrapping the `DynProvider` when you're okay with erasing the type information.

The ideal way is by using the `P: Provider` generic on the encapsulating type. This is depicted by the following [example](https://github.com/alloy-rs/examples/tree/cb2cd9483cfdb8e54744131b34451c996dcc240c/examples/providers/examples/wrapped_provider.rs)

```rust,ignore
{{#include ../../../lib/examples/examples/providers/examples/wrapped_provider.rs}}
```

Sometimes, you're okay with type erasure and don't want to use generics. In those cases, one should use the `DynProvider`.

`DynProvider` erases the type of a provider while maintaining its core functionality.

```rust,ignore
{{#include ../../../lib/examples/examples/providers/examples/dyn_provider.rs}}
```

One might be tempted to `Arc` a `Provider` to enable `Clone` on the struct.

```rust,ignore
#[derive(Clone)]
struct MyProvider<P: Provider> {
    inner: Arc<P>,
}
```

However, this is not required as the inner provider is already `Arc`-ed, and one should just add the `Clone` bound to the `Provider` when needed.

```rust,ignore
struct MyProvider<P: Provider + Clone> {
    inner: P,
}
```
