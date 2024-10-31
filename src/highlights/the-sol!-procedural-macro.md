## The `sol!` procedural macro

The `sol!` procedural macro parses Solidity syntax to generate types that implement [alloy-sol-types](https://github.com/alloy-rs/core/tree/main/crates/sol-types) traits. It uses [`syn-solidity`](https://github.com/alloy-rs/core/tree/main/crates/syn-solidity), a [syn](https://github.com/dtolnay/syn)-powered Solidity parser. It aims to mimic the behavior of the official Solidity compiler (`solc`) when it comes to parsing valid Solidity code. This means that all valid Solidity code, as recognized by `solc` `0.5.0` and above is supported.

In its most basic form `sol!` is used like this:

```rust,ignore
use alloy::{primitives::U256, sol};

// Declare a Solidity type in standard Solidity
sol! {
    #[derive(Debug)] // ... with attributes too!
    struct Foo {
        uint256 bar;
        bool baz;
    }
}

// A corresponding Rust struct is generated:
// #[derive(Debug)]
// pub struct Foo {
//     pub bar: U256,
//     pub baz: bool,
// }

let foo = Foo { bar: U256::from(42), baz: true };
println!("{foo:#?}");
```


### Usage

There are multiple ways to use the `sol!` macro.

You can directly write Solidity code:

```rust,ignore
sol! {
    contract Counter {
        uint256 public number;

        function setNumber(uint256 newNumber) public {
            number = newNumber;
        }

        function increment() public {
            number++;
        }
    }
}
```

Or provide a path to a Solidity file:

```rust,ignore
sol!(
    "artifacts/Counter.sol"
);
```

Alternatively, if you enable the `json` feature flag, you can provide an ABI, or a path to one, in JSON format:

```rust,ignore
sol!(
   ICounter,
   r#"[
        {
            "type": "function",
            "name": "increment",
            "inputs": [],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "number",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "setNumber",
            "inputs": [
                {
                    "name": "newNumber",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [],
            "stateMutability": "nonpayable"
        }
   ]"#
);
```

This is the same as:

```rust,ignore
sol! {
    interface ICounter {
        uint256 public number;

        function setNumber(uint256 newNumber);

        function increment();
    }
}
```

Alternatively, you can load an ABI by file; the format is either a JSON ABI array
or an object containing an `"abi"` key. It supports common artifact formats like Foundry's:

```rust,ignore
sol!(
    ICounter,
    "abi/Counter.json"
);
```

You can also use functions directly:

```rust,ignore
sol!(
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
);

println!("Decoding https://etherscan.io/tx/0xd1b449d8b1552156957309bffb988924569de34fbf21b51e7af31070cc80fe9a");

let input = hex::decode("0x38ed173900000000000000000000000000000000000000000001a717cc0a3e4f84c00000000000000000000000000000000000000000000000000000000000000283568400000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000201f129111c60401630932d9f9811bd5b5fff34e000000000000000000000000000000000000000000000000000000006227723d000000000000000000000000000000000000000000000000000000000000000200000000000000000000000095ad61b0a150d79219dcf64e1e6cc01f0b64c4ce000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7")?;

// Decode the input using the generated `swapExactTokensForTokens` bindings.
let decoded = swapExactTokensForTokensCall::abi_decode(&input, false);
```

### Attributes

Combined with the `sol!` macro's `#[sol(rpc)]` attribute, [`CallBuilder`](https://docs.rs/alloy/latest/alloy/contract/struct.CallBuilder.html) can be used to interact with
on-chain contracts. The `#[sol(rpc)]` attribute generates a method for each function in a contract
that returns a `CallBuilder` for that function.

If `#[sol(bytecode = "0x...")]` is provided, the contract can be deployed with `Counter::deploy` and a new instance will be created.
The bytecode is also loaded from Foundry-style JSON artifact files.

```rust,ignore
//! Example showing how to use the `#[sol(rpc)]` and #[sol(bytecode = "0x...")] attributes
{{#include ../../lib/examples/examples/contracts/examples/deploy_from_contract.rs:2:}}
```
