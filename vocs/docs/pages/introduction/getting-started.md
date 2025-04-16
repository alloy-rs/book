# Getting Started [Quickly connect to a blockchain using alloy]

## Overview

Alloy is a high-performance Rust toolkit for Ethereum and EVM-based blockchains providing developers with:

- **High Performance**: Optimized primitives with up to 60% faster U256 operations and 10x faster ABI encoding
- **Developer Experience**: Intuitive API for interacting with Smart contracts via the `sol!` macro
- **Chain-Agnostic Type System**: Multi-chain support without feature flags or type casting
- **Extensibility**: Customizable provider architecture with layers and fillers

## Installation

Install alloy to any cargo project using the command line. See [Installation](/introduction/installation#features) for more details on the various features flags.

```bash [cargo]
cargo add alloy
```

## Quick Start

### 1. Sending ETH

This example shows how to send 100 ETH using the [`TransactionBuilder`](/transactions/using-the-transaction-builder)

```rust
use alloy::{
    network::TransactionBuilder,
    primitives::{
        address,
        utils::{format_ether, Unit},
        U256,
    },
    providers::{Provider, ProviderBuilder},
    rpc::types::TransactionRequest,
    signers::local::PrivateKeySigner,
};
use eyre::Result;

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize a signer with a private key
    let signer: PrivateKeySigner =
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80".parse()?;

    // Instantiate a provider with the signer
    // This example uses a local Anvil node
    let provider = ProviderBuilder::new()
        .wallet(signer)
        .connect("https://reth-ethereum.ithaca.xyz/rpc")
        .await?;

    // Prepare a transaction request to send 100 ETH to Alice
    let alice = address!("0x70997970C51812dc3A010C7d01b50e0d17dc79C8");
    let value = Unit::ETHER.wei().saturating_mul(U256::from(100));
    let tx = TransactionRequest::default()
        .with_to(alice)
        .with_value(value);

    // Send the transaction and wait for the broadcast
    let pending_tx = provider.send_transaction(tx).await?;
    println!("Pending transaction... {}", pending_tx.tx_hash());

    // Wait for the transaction to be included and get the receipt
    let receipt = pending_tx.get_receipt().await?;
    println!(
        "Transaction included in block {}",
        receipt.block_number.expect("Failed to get block number")
    );

    println!("Transferred {:.5} ETH to {alice}", format_ether(value));

    Ok(())
}
```

### 2. Interacting with Smart Contracts

Alloy's `sol!` macro makes working with smart contracts intuitive by letting you write Solidity directly in Rust:

```rust
use alloy::{
    primitives::{
        address,
        utils::{format_ether, Unit},
        U256,
    },
    providers::ProviderBuilder,
    signers::local::PrivateKeySigner,
    sol,
};
use eyre::Result;

// Generate bindings for the WETH9 contract
sol! {
    #[sol(rpc)]
    contract WETH9 {
        function deposit() public payable;
        function balanceOf(address) public view returns (uint256);
        function withdraw(uint amount) public;
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize a signer with a private key
    let signer: PrivateKeySigner =
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80".parse()?;

    // Instantiate a provider with the signer
    let provider = ProviderBuilder::new()
        .wallet(signer)
        .on_anvil_with_config(|a| a.fork("https://reth-ethereum.ithaca.xyz/rpc"));

    // Setup WETH contract instance
    let weth_address = address!("0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2");
    let weth = WETH9::new(weth_address, provider.clone());

    // Read initial balance
    let from_address = signer.address();
    let initial_balance = weth.balanceOf(from_address).call().await?;
    println!("Initial WETH balance: {} WETH", format_ether(initial_balance));

    // Write: Deposit ETH to get WETH
    let deposit_amount = Unit::ETHER.wei().saturating_mul(U256::from(10));
    let deposit_tx = weth.deposit().value(deposit_amount).send().await?;
    let deposit_receipt = deposit_tx.get_receipt().await?;
    println!(
        "Deposited ETH in block {}",
        deposit_receipt.block_number.expect("Failed to get block number")
    );

    // Read: Check updated balance after deposit
    let new_balance = weth.balanceOf(from_address).call().await?;
    println!("New WETH balance: {} WETH", format_ether(new_balance));

    // Write: Withdraw some WETH back to ETH
    let withdraw_amount = Unit::ETHER.wei().saturating_mul(U256::from(5));
    let withdraw_tx = weth.withdraw(withdraw_amount).send().await?;
    let withdraw_receipt = withdraw_tx.get_receipt().await?;
    println!(
        "Withdrew ETH in block {}",
        withdraw_receipt.block_number.expect("Failed to get block number")
    );

    // Read: Final balance check
    let final_balance = weth.balanceOf(from_address).call().await?;
    println!("Final WETH balance: {} WETH", format_ether(final_balance));

    Ok(())
}
```

### 3. Monitoring Blockchain Activity

This example shows how to monitor blocks and track the balance of a famous contract in real-time:

```rust
use alloy::{
    primitives::{Address, utils::format_ether},
    providers::{Provider, ProviderBuilder},
};
use eyre::Result;
use futures::StreamExt;

#[tokio::main]
async fn main() -> Result<()> {
    // Connect to an Ethereum node via WebSocket
    let provider = ProviderBuilder::new()
        .connect_ws("wss://ethereum.ithaca.xyz/ws")
        .await?;

    // Uniswap V3 ETH-USDC Pool address
    let uniswap_pool = "0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8".parse::<Address>()?;

    // Subscribe to new blocks
    let mut block_stream = provider.subscribe_blocks().await?.into_stream();
    println!("🔄 Monitoring for new blocks...");

    // Process each new block as it arrives
    while let Some(block) = block_stream.next().await {
        println!("🧱 Block #{}: {}", block.header.number, block.header.hash);

        // Get contract balance at this block
        let balance = provider
            .get_balance(uniswap_pool)
            .block_id(block.header.number.into())
            .await?;

        // Format the balance in ETH
        println!("💰 Uniswap V3 ETH-USDC Pool balance: {} ETH", format_ether(balance));
    }

    Ok(())
}
```

## Guides

Check out our Guides to see more practical use cases, including:

- [Building MEV bots with Alloy primitives](/guides/speed-up-using-u256)
- [Seamless contract interaction with the sol! macro](/guides/static-dynamic-abi-in-alloy)
- [Creating custom transaction fillers for setting priority fees](/guides/fillers)
- [Using multicall for aggregating RPC requests](/guides/multicall)
