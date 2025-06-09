---
description: Use the TransactionBuilder to construct transactions with a fluent builder pattern interface
---

## Using the `TransactionBuilder`

The [`TransactionBuilder`](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html) is a network specific transaction builder configurable with `.with_*` methods.

Common fields one can configure are:

- [with_from](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_from)
- [with_to](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_to)
- [with_nonce](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_nonce)
- [with_chain_id](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_chain_id)
- [with_value](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_value)
- [with_gas_limit](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_gas_limit)
- [with_max_priority_fee_per_gas](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_max_priority_fee_per_gas)
- [with_max_fee_per_gas](https://docs.rs/alloy/latest/alloy/network/trait.TransactionBuilder.html#method.with_max_fee_per_blob_gas)

It is generally recommended to use the builder pattern, as shown, rather than directly setting values (`with_to` versus `set_to`).

```rust
// Build a transaction to send 100 wei from Alice to Bob.
let tx = TransactionRequest::default()
        .with_to(bob)
        .with_nonce(0)
        .with_chain_id(provider.get_chain_id().await?)
        .with_value(U256::from(100))
        .with_gas_limit(21_000)
        .with_max_priority_fee_per_gas(1_000_000_000)
        .with_max_fee_per_gas(20_000_000_000);
```
