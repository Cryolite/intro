#!/usr/bin/env sh

{ curl --silent 'http://site.icu-project.org/download' || exit 1; } \
    | { grep -E "ICU4C" || exit 1; } \
    | { grep -oE ">[[:digit:]]+(\\.[[:digit:]]+){0,2}<" || exit 1; } \
    | { tr --delete "><" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head -n 1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }
