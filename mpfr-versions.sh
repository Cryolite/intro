#!/usr/bin/env sh

{ wget --quiet --output-document=- -- 'http://core.ring.gr.jp/pub/GNU/mpfr/' || exit 1; } \
    | { grep -oE 'mpfr-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.tar\.((gz)|(bz2))' || exit 1; } \
    | { grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' || exit 1; } \
    | { sort --version-sort || exit 1; } \
    | { uniq || exit 1; } \
    | { tr '\n' ' ' || exit 1; } \
    | { sed -e 's/^\(.*\) $/\1/' || exit 1; }
