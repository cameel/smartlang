#!/usr/bin/env bash
set -euo pipefail

docker buildx build . --tag "cameel/silesia2025" --progress plain

if (( $# > 0 )) && [[ $1 == "--push" ]]; then
    docker push "cameel/silesia2025"
fi
