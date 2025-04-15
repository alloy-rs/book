# Performant Static and Dynamic ABIs Encoding with Alloy

In this guide, we will discuss new ways to work with blockchain ABIs introduced in [Alloy](https://alloy.rs). We will showcase basic smart contract interactions and how they compare to [ethers-rs](https://github.com/gakonst/ethers-rs). We will also discuss more advanced ways to interact with runtime-constructed dynamic ABIs.

## Alloy ABI 101

Below we have [implemented a simulation](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_u256/examples/alloy_simulation.rs) of an arbitrage swap between two UniswapV2 pairs. We've used the following ABI definitions:

```rust
sol! {
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}

sol!(
    #[sol(rpc)]
    contract IERC20 {
        function balanceOf(address target) returns (uint256);
    }
);

sol!(
    #[sol(rpc)]
    FlashBotsMultiCall,
    "artifacts/FlashBotsMultiCall.json"
);
```

Let's look into these examples in more detail.

### Static calldata encoding

```rust
sol! {
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}
```

Alloy introduces the `sol!` macro that allows to embed compile-time-safe Solidity code directly in your Rust project. In the example, we use it to encode calldata needed for executing `swap` methods for our arbitrage. Here's how you can encode calldata:

[ `examples/sol_encode_calldata.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_abi/examples/sol_encode_calldata.rs)

```rust
let swap_calldata = swapCall {
    amount0Out: U256::from(1000000000000000000_u128)
    amount1Out: U256::ZERO,
    to: sushi_pair.address,
    data: Bytes::new(),
}
.abi_encode();
```

As a result, you'll get a `Vec<u8>` type that you can assign to an `input` field of a transaction.

It's worth noting that `sol!` macro works with any semantically correct Solidity snippets. Here's how you can generate a calldata for a method that accepts a struct.

[ `examples/sol_encode_struct.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_abi/examples/sol_encode_struct.rs)

```rust
sol! {
    struct MyStruct {
        uint256 id;
        string name;
        bool isActive;
    }

    function setStruct(MyStruct memory _myStruct) external;
}

let my_struct = MyStruct {
    id: U256::from(1),
    name: "Hello".to_string(),
    isActive: true,
};

let calldata = setStructCall {
    _myStruct: my_struct.clone(),
}.abi_encode();
```

We've just imported a Solidity struct straight into the Rust code. You can use [`cast interface`](https://book.getfoundry.sh/reference/cast/cast-interface) CLI to generate Solidity snippets for any verified contract:

```bash
cast interface 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 --etherscan-api-key API_KEY
```

it produces:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface WETH9 {
    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    fallback() external payable;

    function allowance(address, address) external view returns (uint256);
    function approve(address guy, uint256 wad) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function decimals() external view returns (uint8);
    function deposit() external payable;
    // ...
}
```

### Performance benchmark ethers-rs vs. Alloy

On top of a nicer API, Alloy also comes with significantly better performance benefits.

We've used the [criterion.rs crate](https://github.com/bheisler/criterion.rs) to produce reliable benchmarks for comparing encoding of static calldata for a method call. The benchmarks can be [found here](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_abi/benches/static_encoding.rs).

```bash
cargo bench

# static_encoding/Ethers time: [746.46 ns 748.47 ns 750.24 ns]
# static_encoding/Alloy  time: [73.544 ns 74.866 ns 75.941 ns]
```

It looks like Alloy is **~10x faster** than ethers-rs! And here's a chart:

![Static ABI encoding performance comparison](/guides-images/alloy_abi/static_encoding_bench.png)

## Interacting with on-chain contracts

Using `#[sol(rpc)]` marco, you can easily generate an interface to an on-chain contract. Let's see it in action:

[ `examples/sol_weth_interface.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_abi/examples/sol_weth_interface.rs)

```rust
sol!(
    #[sol(rpc)]
    contract IERC20 {
        function balanceOf(address target) returns (uint256);
        function name() returns (string);
    }
);

let provider = ProviderBuilder::new().on_http("https://eth.merkle.io".parse()?);
let iweth = IERC20::new(address!("C02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"), provider.clone());
let name = weth.name().call().await?;
println!("Name: {}", name); // => Wrapped Ether
```

Alternatively, instead of defining the interface methods in Solidity, you can use the standard JSON ABI file generated using `cast interface` with `--json` flag:

```bash
cast interface 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 --json --etherscan-api-key API_KEY > abi/weth.json
```

Later you can use it like that:

```rust
sol!(
    IERC20,
    "abi/WETH.json"
);
```

### Deploying Smart Contract with `sol!` macro

To deploy a smart contract, you must use its _"build artifact file"_. It's a JSON file you can generate by running the [`forge build` command](https://book.getfoundry.sh/reference/forge/forge-build):

```shell
forge build contracts/FlashBotsMultiCall.sol
```

It produces a file containing contract's ABI, bytecode, deployed bytecode, and other metadata.

Alternatively, you can use a recently added [`cast artifact` method](https://book.getfoundry.sh/reference/cli/cast/artifact):

```bash
cast artifact 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 --etherscan-api-key $API_KEY --rpc-url $ETH_RPC_URL -o weth.json
```

It generates a minimal artifact file containing contract's bytecode and ABI based on Etherscan and RPC data. Contrary to `forge build`, you don't have to compile contracts locally to use it.

You can later use an artifact file with the `sol!` macro like this:

[ `examples/sol_deploy_contract.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_abi/examples/sol_deploy_contract.rs)

```rust
sol!(
    #[sol(rpc)]
    FlashBotsMultiCall,
    "artifacts/FlashBotsMultiCall.json"
);

let anvil = Anvil::new().fork("https://eth.merkle.io").try_spawn()?;
let wallet_address = anvil.addresses()[0];
let provider = ProviderBuilder::new().on_http(anvil.endpoint().parse()?);
let executor = FlashBotsMultiCall::deploy(provider.clone(), wallet_address).await?;

println!("Executor deployed at: {}", *executor.address());
```

It uses Anvil to fork the mainnet and deploy smart contract to the local network.

You can also use [`cast constructor-args`](https://book.getfoundry.sh/reference/cli/cast/constructor-args) command to check what were the original deployment arguments:

```bash
cast constructor-args 0x6982508145454ce325ddbe47a25d4ec3d2311933 --etherscan-api-key $API_KEY --rpc-url $ETH_RPC_URL

# 0x00000000000000000000000000000000000014bddab3e51a57cff87a50000000 → Uint(420690000000000000000000000000000, 256)
```

We've only discussed a few common ways to use ABI and `sol!` macro in Alloy. Make sure to [check the official docs](https://alloy.rs/highlights/the-sol!-procedural-macro.html) for more examples.

## How to use dynamic ABI encoding?

All the previous examples were using so-called static ABIs, i.e., with format known at the compile time. However, there are use cases where you'll have to work with ABI formats interpreted in the runtime.

One practical example is a backend for a web3 wallet. It's not possible to include all the possible ABIs in the binary. So you'll have to work with JSON ABI files downloaded from the Etherscan API based on a user-provided address.

You can download the ABI for any verified smart contract with the following API call:

```bash
https://api.etherscan.io/api?module=contract&action=getabi&address=ADDRESS&apikey=API_KEY
```

But, for the following example, we'll skip the ABI downloading part. Otherwise, we would need an API key to execute it.

Let's assume that we want to generate a calldata for a [UniswapV2 WETH/DAI pair](https://etherscan.io/address/0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11) `swap` method with arguments provided by a user:

[ `examples/dyn_abi_encoding.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_abi/examples/dyn_abi_encoding.rs)

```rust
fn main() -> Result<()> {
    let input = vec![
        DynSolValue::Uint(uint!(100000000000000000_U256), 256),
        DynSolValue::Uint(U256::ZERO, 256),
        DynSolValue::Address(Address::from([0x42; 20])),
        DynSolValue::Bytes(Bytes::new().into()),
    ];

    let calldata = encode_calldata(
        address!("A478c2975Ab1Ea89e8196811F51A7B7Ade33eB11"),
        "swap".to_string(),
        input,
    )?;

    println!("Calldata: {}", hex::encode(&calldata));
    Ok(())
}

fn encode_calldata(
    address: Address,
    method_name: String,
    params: Vec<DynSolValue>,
) -> Result<Vec<u8>> {
    let abi_filename = format!("./abi/{}-abi.json", address);
    if !Path::new(&abi_filename).exists() {
        return Err(eyre!("ABI file for {} not found", address));
    }

    let abi = read_to_string(&abi_filename)?;
    let json_abi: JsonAbi = serde_json::from_str(&abi)?;

    for item in json_abi.items() {
        if let Some(name) = item.name() {
            if name == &method_name {
                if let AbiItem::Function(func) = item {
                    let result = func.abi_encode_input(&params)?;
                    return Ok(result);
                }
            }
        }
    }

    Err(eyre!("Calldata encoding failed for {}", method_name))
}
```

In the above example, the `encode_calldata` method accepts an address, method name string and vector of `DynSolValue`. We read the local ABI file based on its address and later use it to instantiate the `Function` object based on its string name. Please notice that compared to the previous examples none of these types are compile-time static. We don't use macros or structs, only types that we can dynamically construct from user-provided data.

This approach offers flexibility for interacting with virtually any ABIs that can be defined in a runtime.

### Performance benchmark for dynamic vs static ABI encoding

Let's now compare the performance of generating `swap` method calldata for the same arguments with with Alloy and ethers-rs. You can find the [criterion benchmark here](https://github.com/alloy-rs/writeups/blob/main/code_examples/alloy_abi/benches/dyn_static_encoding.rs).

Here are the results:

```bash
cargo bench

# dyn_encoding/Ethers time: [1.6148 µs 1.6324 µs 1.6579 µs]
# dyn_encoding/Alloy  time: [1.4510 µs 1.4558 µs 1.4618 µs]
```

And a chart:

![Dynamic ABI encoding performance comparison](/guides-images/alloy_abi/dyn_encoding_bench.png)

This time difference is not as dramatic as in static encoding. But Alloy is still ~10% faster than ethers-rs.

## Summary

We've discussed common ways to interact with smart contracts ABI using the new Alloy stack.
