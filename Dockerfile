FROM lukemathwalker/cargo-chef:latest-rust-1 AS chef
WORKDIR /app

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --recipe-path recipe.json

# Install dependencies
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
RUN cargo binstall dioxus-cli --no-confirm

# Build application
COPY . .
RUN dx build --release --features web

# We do not need the Rust toolchain to run the binary!
FROM debian:bookworm-slim AS runtime
WORKDIR /app
COPY --from=builder /app/dist /app/dist
EXPOSE 8080
CMD ["/app/dist/dioxus-odin"]
