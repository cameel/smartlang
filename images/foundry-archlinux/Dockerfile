FROM archlinux:base

# Install general dependencies and handy utilities for end user
RUN <<-EOF
    set -eou pipefail
    pacman --noconfirm -Suy
    pacman --noconfirm --needed -S base-devel git
    pacman --noconfirm --needed -S man-db tree ncdu htop vim nano tmux
    pacman --noconfirm -Scc
EOF

# Install Foundry
RUN curl https://raw.githubusercontent.com/foundry-rs/foundry/master/foundryup/foundryup --output /usr/local/bin/foundryup
RUN chmod 0755 /usr/local/bin/foundryup
RUN mkdir -p /usr/local/share/man/man1
RUN FOUNDRY_DIR=/usr/local foundryup

RUN useradd --create-home --shell /bin/bash user
RUN echo '%user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user
WORKDIR /home/user/

# Smoke test
RUN forge --version
