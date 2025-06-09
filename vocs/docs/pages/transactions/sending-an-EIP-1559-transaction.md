---
description: Send EIP-1559 transactions with dynamic fees using max fee per gas and priority fee settings
---

## Sending an EIP-1559 transaction

Send an [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559) transaction by specifying the `max_fee_per_gas` and `max_priority_fee_per_gas` fields. This is also known as a dynamic or priority fee transaction.

```rust
// [!include ~/snippets/transactions/examples/send_eip1559_transaction.rs]
```
