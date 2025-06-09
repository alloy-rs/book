---
description: Manage different signer types within a single EthereumWallet for flexible transaction signing strategies
---

# Signers vs Ethereum Wallet

## Signer

Signers implement the [`Signer` trait](https://github.com/alloy-rs/alloy/blob/main/crates/signer/src/signer.rs) which enables them to sign hashes, messages and typed data.

Alloy provides access to various signers out of the box such as [`PrivateKeySigner`](https://github.com/alloy-rs/alloy/blob/a3d521e18fe335f5762be03656a3470f5f6331d8/crates/signer-local/src/lib.rs#L37), [`AwsSigner`](https://github.com/alloy-rs/alloy/blob/main/crates/signer-aws/src/signer.rs), [`LedgerSigner`](https://github.com/alloy-rs/alloy/blob/main/crates/signer-ledger/src/signer.rs) etc.

These signers can directly be passed to a `Provider` using the `ProviderBuilder`. These signers are housed in the [`WalletFiller`](https://github.com/alloy-rs/alloy/blob/main/crates/provider/src/fillers/wallet.rs), which is responsible for signing transactions in the provider stack.

For example:

```rust

let signer: PrivateKeySigner = "0x...".parse()?;

let provider = ProviderBuilder::new()
    .wallet(signer)
    .connect_http("http://localhost:8545")?;

```

## `EthereumWallet`

EthereumWallet is a type that can hold multiple different signers such `PrivateKeySigner`, `AwsSigner`, `LedgerSigner` etc and also be passed to the `Provider` using the `ProviderBuilder`.

The signer that instantiates `EthereumWallet` is set as the default signer. This signer is used to sign [`TransactionRequest`] and [`TypedTransaction`] objects that do not specify a signer address in the `from` field.

For example:

```rust
let ledger_signer = LedgerSigner::new(HDPath::LedgerLive(0), Some(1)).await?;
let aws_signer = AwsSigner::new(client, key_id, Some(1)).await?;
let pk_signer: PrivateKeySigner = "0x...".parse()?;

let mut wallet = EthereumWallet::from(pk_signer) // pk_signer will be registered as the default signer.
    .register_signer(aws_signer)
    .register_signer(ledger_signer);

let provider = ProviderBuilder::new()
    .wallet(wallet)
    .connect_http("http://localhost:8545")?;
```

The `PrivateKeySigner` will set to the default signer if the `from` field is not specified. One can hint the `WalletFiller` which signer to use by setting its corresponding address in the `from` field of the `TransactionRequest`.

If you wish to change the default signer after instantiating `EthereumWallet`, you can do so by using the `register_default_signer` method.

```rust
// `pk_signer` will be registered as the default signer
let mut wallet = EthereumWallet::from(pk_signer)
    .register_signer(ledger_signer);

// Changes the default signer to `aws_signer`
wallet.register_default_signer(aws_signer);
```
