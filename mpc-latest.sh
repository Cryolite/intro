#!/usr/bin/env sh

uri_prefix='http://ftp.tsukuba.wide.ad.jp/software/mpc/'
#uri_prefix='http://www.multiprecision.org/index.php?prog=mpc&page=download'

{ curl --silent "$uri_prefix" || exit 1; } \
    | { grep -oE 'mpc-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))' || exit 1; } \
    | { sed -e 's/^mpc-\([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{0,2\}\)\.tar\..*$/\1/' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head -n 1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }
