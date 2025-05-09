# Getting Started [The simplest, fastest Rust toolkit to interact with any EVM chain]

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

### 1. Sending Transactions

This example shows how to send 100 ETH using the [`TransactionBuilder`](/transactions/using-the-transaction-builder) on a local anvil node

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
use std::error::Error;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    // Initialize a signer with a private key
    let signer: PrivateKeySigner =
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80".parse()?;

    // Instantiate a provider with the signer and a local anvil node
    let provider = ProviderBuilder::new() // [!code focus]
        .wallet(signer) // [!code focus]
        .connect("http://127.0.0.1:8545") // [!code focus]
        .await?;

    // Prepare a transaction request to send 100 ETH to Alice
    let alice = address!("0x70997970C51812dc3A010C7d01b50e0d17dc79C8"); // [!code focus]
    let value = Unit::ETHER.wei().saturating_mul(U256::from(100)); // [!code focus]
    let tx = TransactionRequest::default() // [!code focus]
        .with_to(alice) // [!code focus]
        .with_value(value); // [!code focus]

    // Send the transaction and wait for the broadcast
    let pending_tx = provider.send_transaction(tx).await?; // [!code focus]
    println!("Pending transaction... {}", pending_tx.tx_hash());

    // Wait for the transaction to be included and get the receipt
    let receipt = pending_tx.get_receipt().await?; // [!code focus]
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
use std::error::Error;

// Generate bindings for the WETH9 contract
sol! { // [!code focus]
    #[sol(rpc)] // [!code focus]
    contract WETH9 { // [!code focus]
        function deposit() public payable; // [!code focus]
        function balanceOf(address) public view returns (uint256); // [!code focus]
        function withdraw(uint amount) public; // [!code focus]
    } // [!code focus]
} // [!code focus]

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    // Initialize a signer with a private key
    let signer: PrivateKeySigner =
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80".parse()?;

    // Instantiate a provider with the signer
    let provider = ProviderBuilder::new() // [!code focus]
        .wallet(signer) // [!code focus]
        .on_anvil_with_config(|a| a.fork("https://reth-ethereum.ithaca.xyz/rpc"));

    // Setup WETH contract instance
    let weth_address = address!("0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2");
    let weth = WETH9::new(weth_address, provider.clone()); // [!code focus]

    // Read initial balance
    let from_address = signer.address();
    let initial_balance = weth.balanceOf(from_address).call().await?; // [!code focus]
    println!("Initial WETH balance: {} WETH", format_ether(initial_balance));

    // Write: Deposit ETH to get WETH
    let deposit_amount = Unit::ETHER.wei().saturating_mul(U256::from(10));
    let deposit_tx = weth.deposit().value(deposit_amount).send().await?; // [!code focus]
    let deposit_receipt = deposit_tx.get_receipt().await?; // [!code focus]
    println!(
        "Deposited ETH in block {}",
        deposit_receipt.block_number.expect("Failed to get block number")
    );

    // Read: Check updated balance after deposit
    let new_balance = weth.balanceOf(from_address).call().await?;
    println!("New WETH balance: {} WETH", format_ether(new_balance));

    // Write: Withdraw some WETH back to ETH
    let withdraw_amount = Unit::ETHER.wei().saturating_mul(U256::from(5));
    let withdraw_tx = weth.withdraw(withdraw_amount).send().await?; // [!code focus]
    let withdraw_receipt = withdraw_tx.get_receipt().await?; // [!code focus]
    println!(
        "Withdrew ETH in block {}",
        withdraw_receipt.block_number.expect("Failed to get block number")
    );

    // Read: Final balance check
    let final_balance = weth.balanceOf(from_address).call().await?; // [!code focus]
    println!("Final WETH balance: {} WETH", format_ether(final_balance));

    Ok(())
}
```

### 3. Monitoring Blockchain Activity

This example shows how to monitor blocks and track the [WETH](https://etherscan.io/token/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) balance of a [Uniswap V3 WETH-USDC](https://etherscan.io/address/0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8) contract in real-time:

```rust
use alloy::{
    primitives::{address, utils::format_ether},
    providers::{Provider, ProviderBuilder, WsConnect},
    sol,
};
use futures_util::StreamExt;

sol! { // [!code focus]
    #[sol(rpc)] // [!code focus]
    contract WETH { // [!code focus]
        function balanceOf(address) external view returns (uint256); // [!code focus]
    } // [!code focus]
} // [!code focus]

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Connect to an Ethereum node via WebSocket
    let ws = WsConnect::new("wss://reth-ethereum.ithaca.xyz/ws"); // [!code focus]
    let provider = ProviderBuilder::new().connect_ws(ws).await?; // [!code focus]

    // Uniswap V3 WETH-USDC Pool address
    let uniswap_pool = address!("0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8"); // [!code focus]

    // Setup the WETH contract instance
    let weth_addr = address!("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2");
    let weth = WETH::new(weth_addr, &provider); // [!code focus]

    // Subscribe to new blocks
    let mut block_stream = provider.subscribe_blocks().await?.into_stream(); // [!code focus]
    println!("🔄 Monitoring for new blocks...");

    // Process each new block as it arrives
    while let Some(block) = block_stream.next().await { // [!code focus]
        println!("🧱 Block #{}: {}", block.number, block.hash);
        // Get contract balance at this block
        let balance = weth.balanceOf(uniswap_pool).block(block.number.into()).call().await?; // [!code focus]
        // Format the balance in ETH
        println!("💰 Uniswap V3 WETH-USDC pool balance: {} WETH", format_ether(balance));
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
