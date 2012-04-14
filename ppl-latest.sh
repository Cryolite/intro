#!/usr/bin/env sh

uri_prefix='http://bugseng.com/products/ppl/download/ftp/releases/'

{ curl --silent "$uri_prefix" || exit 1; }                          \
    | { grep -oE "[[:digit:]]+(\\.[[:digit:]]+){0,2}/" || exit 1; } \
    | { grep -oE "[[:digit:]]+(\\.[[:digit:]]+){0,2}" || exit 1; }  \
    | { sort -u -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }           \
    | { tail --lines=1 || exit 1; }                                 \
    | { tr --delete '\n' || exit 1; }
