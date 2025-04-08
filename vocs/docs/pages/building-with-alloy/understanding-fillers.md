## Understanding `Fillers`

[Fillers](https://docs.rs/alloy/latest/alloy/providers/fillers/index.html) decorate a [`Provider`](https://docs.rs/alloy/latest/alloy/providers/trait.Provider.html), filling transaction details before they are sent to the network. Fillers are used to set the nonce, gas price, gas limit, and other transaction details, and are called before any other layer.

### Recommended Fillers

`RecommendedFillers` are enabled by default when initializing the `Provider` using `ProviderBuilder::new`.

```rust
// [!include ~/snippets/fillers/examples/recommended_fillers.rs]
```

### Gas Filler

```rust
// [!include ~/snippets/fillers/examples/gas_filler.rs]
```

### Nonce Filler

```rust
// [!include ~/snippets/fillers/examples/nonce_filler.rs]
```

### Wallet Filler

```rust
// [!include ~/snippets/fillers/examples/wallet_filler.rs]
```
