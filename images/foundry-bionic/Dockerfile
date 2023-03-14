FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

# Install Foundry
RUN <<-EOF
    set -eou pipefail

    apt-get update
    apt-get install --assume-yes --no-install-recommends \
        rustc \
        cargo \
        ca-certificates \
        git

    cargo install \
        --git https://github.com/foundry-rs/foundry \
        --profile local \
        --locked \
        --root /usr/local/ \
        foundry-cli anvil chisel

    apt-get remove --assume-yes rustc cargo
    apt-get autoremove --assume-yes
    apt-get clean
EOF

# Smoke test
RUN forge --version
