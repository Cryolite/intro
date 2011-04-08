#!/usr/bin/env sh

wget --quiet --output-document=- -- 'http://core.ring.gr.jp/pub/GNU/gmp/' \
  | grep -oE 'gmp-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.tar\.((gz)|(bz2))' \
  | grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' \
  | sort --version-sort | uniq | tr '\n' ' '
