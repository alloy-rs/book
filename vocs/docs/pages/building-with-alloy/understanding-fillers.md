## Understanding `Fillers`

[Fillers](https://docs.rs/alloy/latest/alloy/providers/fillers/index.html) decorate a [`Provider`](https://docs.rs/alloy/latest/alloy/providers/trait.Provider.html), filling transaction details before they are sent to the network. Fillers are used to set the nonce, gas price, gas limit, and other transaction details, and are called before any other layer.

{{#include ../examples/fillers/recommended_fillers.md}}

{{#include ../examples/fillers/gas_filler.md}}

{{#include ../examples/fillers/nonce_filler.md}}

{{#include ../examples/fillers/wallet_filler.md}}