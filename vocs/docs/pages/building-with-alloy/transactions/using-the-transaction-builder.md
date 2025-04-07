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

```rust,ignore
//! Example showing how to build a transaction using the `TransactionBuilder`
{{#include ../../../lib/examples/examples/transactions/examples/send_eip1559_transaction.rs:2:}}
```

It is recommended to use the `.with_recommended_fillers()` method on the [ProviderBuilder](../connecting-to-a-blockchain/setting-up-a-provider.md) to automatically [fill fields](../understanding-fillers.md) for you.

{{#include ../../examples/fillers/recommended_fillers.md}}