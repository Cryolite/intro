#!/usr/bin/env sh

uri='http://valgrind.org/downloads/current.html'

{ curl --silent "$uri" || exit 1; }                                                     \
    | { grep -Eo "valgrind-[[:digit:]]+(\\.[[:digit:]]+){0,2}\\.tar\\.bz2" || exit 1; } \
    | { grep -Eo "[[:digit:]]+(\\.[[:digit:]]+){0,2}" || exit 1; }                      \
    | { sort -u -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }                               \
    | { tail --lines=1 || exit 1; }                                                     \
    | { tr --delete '\n' || exit 1; }
