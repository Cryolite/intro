#!/usr/bin/env sh

{ curl --silent 'http://www.boost.org/users/history/' || exit 1; }                                \
    | { grep -oE "Version [[:digit:]]+(\\.[[:digit:]]+){0,2}" || exit 1; }                        \
    | { sed -e 's/^Version \([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{0,2\}\)$/\1/' || exit 1; } \
    | { sort -u -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }                                         \
    | { tail --lines=1 || exit 1; }                                                               \
    | { tr --delete '\n' || exit 1; }
