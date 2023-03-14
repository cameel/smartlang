FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

# Install general dependencies and utilities
RUN <<-EOF
    set -eou pipefail
    apt-get update
    apt-get install --assume-yes --no-install-recommends \
        curl \
        wget \
        git \
        ca-certificates \
        gnupg \
        sudo
    apt-get clean
EOF

# Install Mono
RUN <<-EOF
    set -eou pipefail
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" > /etc/apt/sources.list.d/mono-official-stable.list
    apt-get update
    apt-get install --assume-yes --no-install-recommends mono-complete
    apt-get clean
EOF

# Install node.js
RUN <<-EOF
    set -eou pipefail

    keyring=/usr/share/keyrings/nodesource.gpg
    curl --silent --fail --location https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > "$keyring"
    gpg --no-default-keyring --keyring "$keyring" --list-keys
    chmod a+r /usr/share/keyrings/nodesource.gpg

    nodejs_version=node_11.x
    echo "deb [signed-by=${keyring}] https://deb.nodesource.com/${nodejs_version} bionic main" | tee /etc/apt/sources.list.d/nodesource.list
    echo "deb-src [signed-by=${keyring}] https://deb.nodesource.com/${nodejs_version} bionic main" | tee -a /etc/apt/sources.list.d/nodesource.list

    apt-get update
    apt-get install --assume-yes --no-install-recommends nodejs
    apt-get clean
EOF

# Install Swift compiler
RUN <<-EOF
    set -eou pipefail
    swift_version=5.0.2
    swift_url="https://download.swift.org/swift-${swift_version}-release/ubuntu1804/swift-${swift_version}-RELEASE/swift-${swift_version}-RELEASE-ubuntu18.04.tar.gz" && \
    mkdir /opt/swift/
    cd /opt/swift/
    curl --location "$swift_url" | tar --extract --gzip
    mv "swift-${swift_version}-RELEASE-ubuntu18.04/" "$swift_version"
    ln -s "/opt/swift/${swift_version}/usr/bin/swift" /usr/local/bin/swift
EOF

# Install Flint dependencies
RUN <<-EOF
    set -eou pipefail
    apt-get update
    apt-get install --assume-yes --no-install-recommends clang z3
    apt-get clean
EOF

# Create a non-root user with sudo access
RUN useradd --create-home --shell /bin/bash user
RUN echo '%user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user

# Build Flint compiler
# NOTE: Flint is very picky about where it's installed. It's apparently hardcoded to expect some files in ~/.flint/
# This includes files that are in the repo outside of its build directory. It seems impossible to install it globally
# because it ignores $HOME (assumes home dir based on user name?).
RUN <<-EOF
    set -eou pipefail

    cd
    git clone --recurse-submodule https://github.com/flintlang/flint .flint
    cd .flint/
    npm install
    swift package update
    make release

    rm -r ~/.npm/
    rm -r ~/.local/share/NuGet/
    rm -r ~/.flint/.git/
    rm -r ~/.flint/.build/release/ModuleCache/
    rm -r ~/.flint/.build/repositories/
    rm -r ~/.flint/.build/checkouts/
EOF
RUN echo 'export PATH="~/.flint/.build/release/:$PATH"' >> ~/.bash_profile
RUN echo 'source ~/.bash_profile' >> ~/.bashrc

USER root

# Install Solidity compiler
RUN <<-EOF
    set -eou pipefail
    curl https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.4.25+commit.59dbf8f1 --output /usr/bin/solc
    chmod 0755 /usr/bin/solc
EOF

# Install some handy utilities for the end user (last so that changes do not invalidate previous layers)
RUN <<-EOF
    set -eou pipefail
    apt-get update
    apt-get install --assume-yes --no-install-recommends man-db tree ncdu htop vim nano tmux
    apt-get clean
EOF

USER user
WORKDIR /home/user/

# Smoke test
RUN source ~/.bash_profile && flintc
