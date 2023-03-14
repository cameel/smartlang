#!/usr/bin/env bash
set -euo pipefail

images=(
    foundry-archlinux
    vyper-archlinux
    lira-archlinux
    flint-bionic
    foundry-bionic
)

for image in "${images[@]}"; do
    pushd "$image"
    docker buildx build . --tag "cameel/${image}" --progress plain
    popd

    if (( $# > 0 )) && [[ $1 == "--push" ]]; then
        docker push "cameel/${image}"
    fi
done
