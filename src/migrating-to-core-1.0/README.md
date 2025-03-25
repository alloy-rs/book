# Core v1.0 Highlights

### Revamping the `sol!` macro bindings

- [Contract and RPC codegen made cleaner by removal of the `T` tranport generic](./sol!-changes/removing-T-generic.md)
- [Improving the function return types by removing the need for `_0`](./sol!-changes/improving-function-return-types.md)
- [Changes to function call bindings e.g `pub struct balanceOfCall { _0: Address }` to `pub struct balanceOfCall(pub Address)`](./sol!-changes/changes-to-function-call-bindings.md)
- [Changes to event bindings](./sol!-changes/changes-to-event-bindings.md)
- [Changes to error bindings](./sol!-changes/changes-to-error-bindings.md)

### Simplify ABI encoding and decoding

- [ABI encoding function return structs](./encoding-decoding-changes/encoding-return-structs.md)
- [Removing `validate: bool` from the `abi_decode` methods](./encoding-decoding-changes/removing-validate-bool.md)

### Other breaking changes

- [Removal of the deprecated `Signature` type. `PrimitiveSignature` is now aliased to `Signature`](https://github.com/alloy-rs/core/pull/899)
- [Renaming methods in User-defined types (UDT)'s bindings and implementing `From` and `Into` traits for UDT's](https://github.com/alloy-rs/core/pull/905)
- [Bumping `getrandom` and `rand`](https://github.com/alloy-rs/core/pull/869)
- [Removal of `From<String>` for `Bytes`](https://github.com/alloy-rs/core/pull/907)

If you'd like to dive into the details of each change, please take a look at this [PR](https://github.com/alloy-rs/core/pull/895)
