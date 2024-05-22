#!/bin/bash

# Install TailwindCSS
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
mv tailwindcss-linux-x64 tailwindcss

# Install Rust toolchain
curl https://sh.rustup.rs -sSf | sh -s -- -y
PATH=$PATH:/vercel/.cargo/bin

# Install wasm target
rustup target add wasm32-unknown-unknown

# Install wasm-bindgen
# cargo install wasm-bindgen-cli
curl -sLo https://github.com/rustwasm/wasm-bindgen/releases/download/0.2.92/wasm-bindgen-0.2.92-x86_64-unknown-linux-musl.tar.gz
tar -xvf wasm-bindgen-0.2.92-x86_64-unknown-linux-musl.tar.gz
mv wasm-bindgen-0.2.92-x86_64-unknown-linux-musl/wasm-bindgen /vercel/.cargo/bin/

# Install trunk
# cargo install --locked trunk
curl -sLo https://github.com/trunk-rs/trunk/releases/download/v0.20.1/trunk-x86_64-unknown-linux-gnu.tar.gz
tar -xvf trunk-x86_64-unknown-linux-gnu.tar.gz
mv trunk /vercel/.cargo/bin/

