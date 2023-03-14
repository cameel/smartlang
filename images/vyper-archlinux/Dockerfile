FROM cameel/foundry-archlinux
USER root

# Install dependencies
RUN <<-EOF
    set -eou pipefail
    pacman --noconfirm -Suy
    pacman --noconfirm --needed -S python-pip
    pacman --noconfirm -Scc
EOF

# Install Vyper compiler
RUN pip install vyper --no-cache-dir

# Install Solidity compiler
RUN <<-EOF
    set -eou pipefail
    pacman --noconfirm -S solidity z3
    pacman --noconfirm -Scc
EOF

USER user

# Smoke test
RUN vyper --version
RUN solc --version
