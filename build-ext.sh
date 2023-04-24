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
  cd stellarisdashboard/parsing/rust_parser
  # https://github.com/PyO3/maturin/issues/284
  env VIRTUAL_ENV=$(python3 -c 'import sys; print(sys.base_prefix)') maturin develop -r
  #rm -rf "$HOME/.cargo/registry"
  rustup self uninstall -y
fi
