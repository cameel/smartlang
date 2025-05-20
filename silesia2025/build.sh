#!/usr/bin/env bash
set -euo pipefail

# This assumes https://github.com/webpro/reveal-md is installed globally.
reveal-md \
    slides.md \
    --title "What's holding back better smart contract languages and tools on Ethereum?" \
    --css style.css \
    --theme white \
    "$@"
