#!/usr/bin/env sh

{ curl --silent 'http://www.boost.org/users/history/' || exit 1; } \
    | { grep -oE "Version [[:digit:]]+(\\.[[:digit:]]+){0,2}" || exit 1; } \
    | { sed -e 's/^Version \([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{0,2\}\)$/\1/' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head -n 1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }
