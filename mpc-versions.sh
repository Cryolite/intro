#!/usr/bin/env sh

{ wget --quiet --output-document=- -- 'http://www.multiprecision.org/index.php?prog=mpc&page=download' || exit 1; } \
    | { grep -oE 'mpc-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))' || exit 1; } \
    | { grep -oE '[[:digit:]]+(\.[[:digit:]]+){0,2}' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { tr '\n' ' ' || exit 1; } \
    | { sed -e 's/^\(.*\) $/\1/' || exit 1; }
