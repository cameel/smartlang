FROM archlinux:base

RUN useradd --create-home --shell /bin/bash user
RUN echo '%user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user
WORKDIR /home/user/

USER root

# Install general dependencies and handy utilities for end user
RUN <<-EOF
    set -eou pipefail
    pacman --noconfirm -Suy
    pacman --noconfirm --needed -S base-devel git unzip man-db tree ncdu htop vim nano tmux wget
    pacman --noconfirm --needed -S python-pip python-virtualenv
    pacman --noconfirm --needed -S rust
    pacman --noconfirm --needed -S z3
    pacman --noconfirm -Scc
EOF

# Install Foundry
RUN curl https://raw.githubusercontent.com/foundry-rs/foundry/master/foundryup/foundryup --output /usr/local/bin/foundryup
RUN chmod 0755 /usr/local/bin/foundryup
RUN mkdir -p /usr/local/share/man/man1
RUN FOUNDRY_DIR=/usr/local foundryup

# Install Solidity compiler
RUN <<-EOF
    set -eou pipefail
    curl https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.8.30+commit.73712a01 --output /usr/local/bin/solc
    chmod +x /usr/local/bin/solc
    pacman --noconfirm -S z3
    pacman --noconfirm -Scc
EOF

# Install heimdall-rs
RUN <<-EOF
    set -eou pipefail
    curl https://github.com/Jon-Becker/heimdall-rs/releases/download/0.8.7/heimdall-linux-amd64 --location --output /usr/local/bin/heimdall
    chmod +x /usr/local/bin/heimdall
EOF

# Install hevm
RUN <<-EOF
    set -eou pipefail
    curl https://github.com/ethereum/hevm/releases/download/release%2F0.54.2/hevm-x86_64-linux --location --output /usr/local/bin/hevm
    chmod +x /usr/local/bin/hevm
EOF

# Install Vyper
RUN <<-EOF
    set -eou pipefail
    mkdir /opt/vyper/
    virtualenv /opt/vyper/venv/
    source /opt/vyper/venv/bin/activate
    pip install vyper --no-cache-dir
    ln --symbolic /opt/vyper/venv/bin/vyper /usr/local/bin/vyper
EOF

USER user

# Smoke test
RUN forge --version
RUN solc --version
RUN heimdall --version
RUN hevm version
RUN vyper --version
