#!/usr/bin/env sh

{ wget --quiet --output-document=- -- 'http://core.ring.gr.jp/pub/GNU/mpfr/' || exit 1; } \
    | { grep -oE 'mpfr-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))' || exit 1; } \
    | { grep -oE '[[:digit:]]+(\.[[:digit:]]+){0,2}' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { tr '\n' ' ' || exit 1; } \
    | { sed -e 's/^\(.*\) $/\1/' || exit 1; }
