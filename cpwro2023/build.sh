#!/usr/bin/env bash
set -euo pipefail

# Generate wordcloud images.
# This requires python-wordcloud.
wordcloud_cli \
    --width 800 \
    --height 500 \
    --background white \
    --random_state 42 \
    --text other-blockchain-languages.txt \
    --imagefile other-blockchain-languages-wordcloud.png
wordcloud_cli \
    --width 800 \
    --height 500 \
    --background white \
    --random_state 42 \
    --text zk-languages.txt \
    --imagefile zk-languages-wordcloud.png

# This assumes https://github.com/webpro/reveal-md is installed globally.
reveal-md \
    slides.md \
    --title "Smart Contract languages of the EVM: What else is there besides Solidity?" \
    --css style.css \
    --theme white \
    "$@"
