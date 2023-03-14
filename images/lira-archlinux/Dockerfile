FROM cameel/foundry-archlinux
USER root

# Build and install Lira compiler
RUN <<-EOF
    set -eou pipefail
    pacman --noconfirm -S stack
    pacman --noconfirm -Scc
    cd /tmp/
    git clone --recurse-submodule https://github.com/etoroxlabs/lira
    cd lira/
    # The original commit exists on Github but is not attached to any branch/tag and `stack install` fails.
    # We'll use the latest commit from `master` as of 2023-03-12.
    sed -i -e 's|commit: b60348b4f4d8e548f5f2debbe498371b2a3f307c|commit: 749da6f52b7870329d35b608c0212e18cdb48f94|' stack.yaml
    stack install --local-bin-path /usr/local/bin
    rm -r /tmp/lira/ ~/.stack/
    pacman --noconfirm -Rsc stack
EOF

USER user

# Smoke test
RUN lirac <(echo "translate(now,zero)") --output /tmp/ && rm /tmp/*.{abi,bin}
