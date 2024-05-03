# Summary

[Introduction](./README.md)

# Getting Started

- [Installation](./getting-started/installation.md)
- [First steps with Alloy](./getting-started/first-steps.md)

# Tutorials

# [Migrating from `ethers-rs`](./migrating-from-ethers/reference.md)

- [Reference](./migrating-from-ethers/reference.md)

# [Building with Alloy](./building-with-alloy/basic-building-blocks/using-big-numbers)

- [Basic building blocks](./building-with-alloy/basic-building-blocks/using-big-numbers.md)
  - [Using big numbers](./building-with-alloy/basic-building-blocks/using-big-numbers.md)
  - [Basic hash and address types](./building-with-alloy/basic-building-blocks/basic-hash-and-address-types.md)
  - [Common conversions](./building-with-alloy/basic-building-blocks/common-conversions.md)
  - [Creating instances](./building-with-alloy/basic-building-blocks/creating-instances.md)
  - [Comparisons and equivalence](./building-with-alloy/basic-building-blocks/comparisons-and-equivalence.md)

# Examples

<!-- MANUALLY MAINTAINED -->
<!-- TO UPDATE EXAMPLES RUN: `./scripts/update.sh` AND MAKE MODIFICATIONS IF NECESSARY -->
- [Anvil](./examples/anvil/deploy_contract_anvil.md)
  - [Deploy contract](./examples/anvil/deploy_contract_anvil.md)
  - [Fork](./examples/anvil/fork_anvil.md)
  - [Local](./examples/anvil/local_anvil.md)
- [Big numbers](./examples/big-numbers/comparison_equivalence.md)
  - [Comparison and equivalence](./examples/big-numbers/comparison_equivalence.md)
  - [Conversion](./examples/big-numbers/conversion.md)
  - [Creating instances](./examples/big-numbers/create_instances.md)
  - [Math operations](./examples/big-numbers/math_operations.md)
  - [Math utilities](./examples/big-numbers/math_utilities.md)
- [Contracts](./examples/contracts/deploy_from_artifact.md)
  - [Deploy from artifact](./examples/contracts/deploy_from_artifact.md)
  - [Deploy from contract](./examples/contracts/deploy_from_contract.md)
  - [Interact with ABI](./examples/contracts/interact_with_abi.md)
- [Fillers](./examples/fillers/gas_filler.md)
  - [Gas estimation filler](./examples/fillers/gas_filler.md)
  - [Nonce management filler](./examples/fillers/nonce_filler.md)
  - [Recommended fillers](./examples/fillers/recommended_fillers.md)
  - [Signer management filler](./examples/fillers/signer_filler.md)
- [Providers](./examples/providers/builder.md)
  - [Builder](./examples/providers/builder.md)
  - [Builtin](./examples/providers/builtin.md)
  - [HTTP](./examples/providers/http.md)
  - [IPC](./examples/providers/ipc.md)
  - [WebSocket](./examples/providers/ws.md)
  - [WebSocket with authentication](./examples/providers/ws_with_auth.md)
- [Queries](./examples/queries/query_contract_storage.md)
  - [Query contract storage](./examples/queries/query_contract_storage.md)
  - [Query contract deployed bytecode](./examples/queries/query_deployed_bytecode.md)
  - [Query logs](./examples/queries/query_logs.md)
- [Subscriptions](./examples/subscriptions/subscribe_blocks.md)
  - [Watch and poll for contract event logs](./examples/subscriptions/poll_logs.md)
  - [Subscribe and watch blocks](./examples/subscriptions/subscribe_blocks.md)
  - [Subscribe and listen for contract event logs](./examples/subscriptions/subscribe_logs.md)
  - [Event multiplexer](./examples/subscriptions/event_multiplexer.md)
- [Transactions](./examples/transactions/decode_input.md)
  - [Decode input](./examples/transactions/decode_input.md)
  - [Get gas price in USD](./examples/transactions/gas_price_usd.md)
  - [Trace call](./examples/transactions/trace_call.md)
  - [Trace transaction](./examples/transactions/trace_transaction.md)
  - [Transfer ERC20 token](./examples/transactions/transfer_erc20.md)
  - [Transfer ETH](./examples/transactions/transfer_eth.md)
  - [Sign and send a raw transaction](./examples/transactions/sign_transaction.md) 
  - [Send transaction with access list](./examples/transactions/with_access_list.md)
- [Wallets](./examples/wallets/aws_signer.md)
  - [AWS signer](./examples/wallets/aws_signer.md)
  - [Ledger signer](./examples/wallets/ledger_signer.md)
  - [Private key signer](./examples/wallets/private_key_signer.md)
  - [Mnemonic signer](./examples/wallets/mnemonic_signer.md)
  - [Sign message](./examples/wallets/sign_message.md)
  - [Sign permit hash](./examples/wallets/sign_permit_hash.md)
  - [Trezor signer](./examples/wallets/trezor_signer.md)
  - [Yubi signer](./examples/wallets/yubi_signer.md)
  - [Keystore signer](./examples/wallets/keystore_signer.md)
  - [Create keystore](./examples/wallets/create_keystore.md)
<!-- MANUALLY MAINTAINED -->

# Appendix

- [Glossary](./appendix/glossary.md)
- [Help us improve Alloy](./appendix/contributing.md)