#!/bin/sh
#set -x
set -e
echo "Building Cython/Rust extensions"

cd /home/stellaris/stellaris-dashboard

python setup.py build_ext --inplace

if [ -e stellarisdashboard/parsing/rust_parser ]; then
  curl -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
  case "`gcc -dumpmachine`" in
    *"-musl")  export RUSTFLAGS="-C target-feature=-crt-static" ;;
    *) ;;
  esac
  cargo build --release --manifest-path=stellarisdashboard/parsing/rust_parser/Cargo.toml
  cp -p ./stellarisdashboard/parsing/rust_parser/target/release/librust_parser.so ./rust_parser.so
  #rm -rf "$HOME/.cargo/registry"
  rustup self uninstall -y
fi
