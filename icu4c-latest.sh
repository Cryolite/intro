#!/usr/bin/env sh

{ curl --silent 'http://site.icu-project.org/download' || exit 1; }  \
    | { grep -E "ICU4C" || exit 1; }                                 \
    | { grep -oE ">[[:digit:]]+(\\.[[:digit:]]+){0,3}<" || exit 1; } \
    | { tr --delete "><" || exit 1; }                                \
    | { sort -u -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n || exit 1; }    \
    | { tail --lines=1 || exit 1; }                                  \
    | { tr --delete '\n' || exit 1; }
