# 📖 Alloy Book

A book on all things Alloy.

[![Telegram chat][telegram-badge]][telegram-url]

[`ethers-rs`]: https://github.com/gakonst/ethers-rs
[telegram-badge]: https://img.shields.io/endpoint?color=neon&style=for-the-badge&url=https%3A%2F%2Ftg.sumanjay.workers.dev%2Fethers_rs
[telegram-url]: https://t.me/ethers_rs

## Contributing

Thanks for your help improving the project! We are so happy to have you! We have
[a contributing guide](./CONTRIBUTING.md) to help you get involved in the
Alloy project.

The book is build with [`mdbook`](https://github.com/rust-lang/mdBook), which you can get by running `cargo install mdbook`.

The book also requires [mdbook-external-links](https://github.com/jonahgoldwastaken/mdbook-external-links): `cargo install mdbook-external-links`.

To see the book change live run:

```sh
mdbook serve
```

To run the book with docker, run:

```sh
docker run -p 3000:3000 -v `pwd`:/book peaceiris/mdbook serve
```

#### License

<sup>
Licensed under either of <a href="LICENSE-APACHE">Apache License, Version
2.0</a> or <a href="LICENSE-MIT">MIT license</a> at your option.
</sup>

<br>

<sub>
Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in these crates by you, as defined in the Apache-2.0 license,
shall be dual licensed as above, without any additional terms or conditions.
</sub>
