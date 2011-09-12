#!/usr/bin/env sh

{ curl --silent 'http://core.ring.gr.jp/pub/GNU/mpfr/' || exit 1; } \
    | { grep -oE "mpfr-[[:digit:]]+(\\.[[:digit:]]+){0,2}\\.tar\\.((gz)|(bz2))" || exit 1; } \
    | { sed -e 's/^mpfr-\([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{0,2\}\)\.tar\..*$/\1/' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head -n 1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }
