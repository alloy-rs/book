---
description: Send legacy transactions with gas price for compatibility with older Ethereum networks
---

## Sending a legacy transaction

Send a [pre-EIP-2718](https://eips.ethereum.org/EIPS/eip-2718) legacy transaction by specifying the `gas_price` field.

```rust
// [!include ~/snippets/transactions/examples/send_legacy_transaction.rs]
```
