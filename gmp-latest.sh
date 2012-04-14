#!/usr/bin/env sh

uri_prefix='http://ftp.jaist.ac.jp/pub/GNU/gmp/'
#uri_prefix='http://ftp.tsukuba.wide.ad.jp/software/gmp/' # Tsukuba Univ., Ibaraki, Japan ++
#uri_prefix='http://ftp.nara.wide.ad.jp/pub/GNU/gnu/gmp/' # NAIST, Nara, Japan +++
#uri_prefix='http://www.ring.gr.jp/archives/GNU/gmp/'

{ curl --silent "$uri_prefix" || exit 1; }                                                             \
    | { grep -oE "gmp-[[:digit:]]+(\\.[[:digit:]]+){0,2}\\.tar\\.((gz)|(bz2))" || exit 1; }            \
    | { sed -e 's/^gmp-\([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{0,2\}\)\.tar\..*$/\1/' || exit 1; } \
    | { sort -u -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }                                              \
    | { tail --lines=1 || exit 1; }                                                                    \
    | { tr --delete '\n' || exit 1; }
