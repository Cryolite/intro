#!/usr/bin/env sh

{ curl --silent -L 'http://www.open-mpi.org/software/' || exit 1; }                                        \
    | { grep -oE "openmpi-[[:digit:]]+(\\.[[:digit:]]+){0,2}\\.tar\\.((gz)|(bz2))" || exit 1; }            \
    | { sed -e 's/^openmpi-\([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{0,2\}\)\.tar\..*$/\1/' || exit 1; } \
    | { sort -u -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }                                                  \
    | { tail --lines=1 || exit 1; }                                                                        \
    | { tr --delete '\n' || exit 1; }
