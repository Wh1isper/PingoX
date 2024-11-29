FROM rustlang/rust:nightly AS builder

WORKDIR /app

COPY . .

RUN cargo build --release

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/target/release/pingox .

RUN apt-get update && apt-get install -y tini && rm -rf /var/lib/apt/lists/*
RUN chmod +x pingox

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["./pingox"]
