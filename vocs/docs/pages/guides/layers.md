# Customizing RPC Communication with Alloy's Layers

In the [previous guide](/guides/fillers), we covered [Alloy fillers](/rpc-providers/understanding-fillers). This time we'll discuss how to use [Alloy layers](https://alloy.rs/examples/layers/README) to customize HTTP-related aspects of RPC client communication.

## Layers 101

To better understand layers, we first have to explore the [Tower crate](https://github.com/tower-rs/tower). It's a basic building block for many popular Rust tools, including [Reqwest](https://github.com/seanmonstar/reqwest), [Hyper](https://github.com/hyperium/hyper), [Axum](https://github.com/tokio-rs/axum), and, of course, Alloy.

What all these crates have in common is that they work with HTTP request/response communication. That's where Tower comes into play. It's an opinionated framework for constructing pipelines for `Request -> Response` transformations. Tower also comes with a set of built-in layers that add functionality like rate limiting, compression, retry logic, logging, etc.

Check out [this classic blog post](https://tokio.rs/blog/2021-05-14-inventing-the-service-trait) for a more in-depth explanation of the origins of the Tower `Service` trait. To better understand `Service` and `Layer` traits, let's implement a barebones `Request/Response` processing pipeline using Tower.

### Basic tower service and layer implementation

Here's a barebones service that prepends `"Hello "` to its argument:

```rust
struct MyService;

impl Service<String> for MyService {
    type Response = String;
    type Error = ();
    type Future = Ready<Result<Self::Response, Self::Error>>;

    fn poll_ready(&mut self, _cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        Poll::Ready(Ok(()))
    }

    fn call(&mut self, req: String) -> Self::Future {
        ready(Ok(format!("Hello {}!", req)))
    }
}
```

It's a bit verbose for its minimal functionality. Please refer to the [_inventing the service layer_ post](https://tokio.rs/blog/2021-05-14-inventing-the-service-trait) understand the origin of this boilerplate better.

Here's how you can use it:

```rust
#[tokio::main]
async fn main() {
    let mut service = ServiceBuilder::new().service(MyService);

    let response = service.call("Alice".to_string()).await;
    match response {
        Ok(msg) => println!("{}", msg),
        Err(_) => eprintln!("An error occurred!"),
    }
}
```

Let's make it a bit more interesting by implementing a custom layer:

```rust
struct DelayLayer {
    delay: Duration,
}

impl DelayLayer {
    fn new(delay: Duration) -> Self {
        Self { delay }
    }
}

impl<S> Layer<S> for DelayLayer {
    type Service = DelayService<S>;

    fn layer(&self, service: S) -> Self::Service {
        DelayService {
            service,
            delay: self.delay,
        }
    }
}

struct DelayService<S> {
    service: S,
    delay: Duration,
}

impl<S, Request> Service<Request> for DelayService<S>
where
    S: Service<Request> + Send,
    S::Future: Send + 'static,
{
    type Response = S::Response;
    type Error = S::Error;
    type Future = BoxFuture<'static, Result<Self::Response, Self::Error>>;

    fn poll_ready(&mut self, cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        self.service.poll_ready(cx)
    }

    fn call(&mut self, req: Request) -> Self::Future {
        let delay = self.delay;
        let future = self.service.call(req);

        Box::pin(async move {
            sleep(delay).await;
            future.await
        })
    }
}
```

It's also a bit verbose, but this overhead is necessary to make the compiler happy. A core functionality of our layer is implemented in the `call` method. You can see that it wraps the unresolved future and delays it by calling `sleep`. This implementation is similar to how we can modify the Alloy `Request/Response` cycle. It's worth noting that while `MyService` defines a specific `Type = String` type, `DelayLayer` is generic. It will come in handy very soon.

Here's our delay layer in action:

[ `examples/tower_basic.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/layers/examples/tower_basic.rs)

```rust
#[tokio::main]
async fn main() {
    let mut service = ServiceBuilder::new()
        .layer(DelayLayer::new(Duration::from_secs(5)))
        .service(MyService);

    let response = service.call("Alice".to_string()).await;
    match response {
        Ok(msg) => println!("{}", msg),
        Err(_) => eprintln!("An error occurred!"),
    }
}
```

Running this example outputs _"Hello Alice!"_ after a 5-second delay:

```bash
cargo run --example tower_basic
```

Layers might sound similar to the fillers, but there's a crucial difference. Fillers can be used to modify the `TransactionRequest` object before it is submitted. Layers work within the `Request/Response` scope, allowing us to customize logic before and after sending the RPC request. If you're familiar with the Alloy predecessor Ethers.rs, you've probably noticed that it used [middleware](https://www.gakonst.com/ethers-rs/middleware/middleware.html) to achieve the same result.

## How to use layers in Alloy

Now that we've covered the basics let's see how layers fit within the Alloy stack. In this context, a `Service` is the Alloy `Provider`, and we can tweak how it sends RPC requests and handles responses.

Let's start with a simple example of reusing our `DelayLayer` for Alloy providers. This particular example does not have the best practical use case, but it shows that some generic layers can be reused regardless of the underlying `Service` `Request` type:

[ `examples/alloy_delay.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/layers/examples/alloy_delay.rs)

```rust
#[tokio::main]
async fn main() -> Result<()> {
    let anvil = Anvil::new().try_spawn()?;
    let signer: PrivateKeySigner = anvil.keys()[0].clone().into();

    let client = ClientBuilder::default()
        .layer(DelayLayer::new(Duration::from_secs(1)))
        .http(anvil.endpoint().parse()?);

    let provider = ProviderBuilder::new()
        .wallet(signer)
        .on_client(client);

    let bob = Address::from([0x42; 20]);
    let tx = TransactionRequest::default()
        .with_to(bob)
        .with_value(U256::from(1));

    let bob_balance_before = provider.get_balance(bob).await?;
    _ = provider.send_transaction(tx).await?.get_receipt().await?;
    let bob_balance_after = provider.get_balance(bob).await?;
    println!(
        "Balance before: {}\nBalance after: {}",
        bob_balance_before, bob_balance_after
    );

    Ok(())
}
```

Execute it like this:

```bash
cargo run --example alloy_delay
# Balance before: 0
# Balance after: 1
```

You'll notice a considerable delay before it executes. Let's add logging to better understand where it's coming from.

### Using logging layer for Alloy provider

We will use a popular [Tracing crate](https://github.com/tokio-rs/tracing) to display logs on each RPC request. Here's the implementation:

```rust
struct LoggingLayer;

impl<S> Layer<S> for LoggingLayer {
    type Service = LoggingService<S>;

    fn layer(&self, inner: S) -> Self::Service {
        LoggingService { inner }
    }
}

#[derive(Debug, Clone)]
struct LoggingService<S> {
    inner: S,
}

impl<S> Service<RequestPacket> for LoggingService<S>
where
    S: Service<RequestPacket, Response = ResponsePacket, Error = TransportError>,
    S::Future: Send + 'static,
    S::Response: Send + 'static + Debug,
    S::Error: Send + 'static + Debug,
{
    type Response = S::Response;
    type Error = S::Error;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response, Self::Error>> + Send>>;

    fn poll_ready(&mut self, cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        self.inner.poll_ready(cx)
    }

    fn call(&mut self, req: RequestPacket) -> Self::Future {
        tracing::info!("Request: {req:?}");

        let fut = self.inner.call(req);

        Box::pin(async move {
            let res = fut.await;
            tracing::info!("Response: {res:?}");
            res
        })
    }
}
```

You can notice that it's very similar to the `DelayLayer`. Core logic lives in the `call` method, and instead of delaying requests with `sleep`, we use `tracing::info!` calls to log them.

Here's how you can connect it to the provider:

[ `examples/alloy_logging.rs`](https://github.com/alloy-rs/writeups/blob/main/code_examples/layers/examples/alloy_logging.rs)

```rust
let client = ClientBuilder::default()
    .layer(DelayLayer::new(Duration::from_secs(1)))
    .layer(LoggingLayer)
    .http(anvil.endpoint().parse()?);
let provider = ProviderBuilder::new()
    .wallet(signer)
    .on_client(client);
```

Now run this example:

```bash
RUST_LOG=info cargo run --example alloy_logging
```

![Alloy logging](/guides-images/layers/alloy_logs.png)

You can see that our simple example triggered various RPC requests: `eth_blockNumber`, `eth_getBlockByNumber`, `eth_chainId`, `eth_transactionCount`, `eth_getBalance`, and more.

Thanks to the custom layer we can fine-tune the `LoggingLayer` policy and for example only log RPC calls sending transactions:

```rust
fn call(&mut self, req: RequestPacket) -> Self::Future {
    if let RequestPacket::Single(req) = &req {
        if req.method() == "eth_sendTransaction" || req.method() == "eth_sendRawTransaction" {
            tracing::info!("Request: {req:?}");
        };
    }

    let fut = self.inner.call(req);

    Box::pin(fut)
}
```

Running this reworked example produces a much cleaner output:

![Alloy logging txs](/guides-images/layers/alloy_logs_tx.png)

You can see that layers provide powerful low-level control over how the provider handles RPC calls.

## Summary

Alloy layers combined with fillers allow for elaborate customization of transaction dispatch logic. Mastering these APIs could save you a lot of manual tweaking and enable building robust provider pipelines fine-tuned to your application requirements.
