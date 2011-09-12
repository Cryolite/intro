#!/usr/bin/env sh

#url='http://core.ring.gr.jp/pub/GNU/gcc/'
url_prefix='http://ftp.tsukuba.wide.ad.jp/software/gcc'

versions=`{ curl --silent "${url_prefix}/releases/" || exit 1; } \
    | { grep -oE "gcc-[[:digit:]]+(\\.[[:digit:]]+){0,2}/" || exit 1; } \
    | { sed -e 's/^gcc-\([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{0,2\}\)\/$/\1/' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; }`

majors=`/bin/echo -n "$versions" \
    | { grep -oE "^[[:digit:]]+\\.[[:digit:]]+" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=4 || exit 1; }`

builtin=`{ (LANG=C g++ --version) || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { grep -oE "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+$" || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

current_major=`/bin/echo -n "$majors" \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
current=`/bin/echo -n "$versions" \
    | { grep -oE "^$current_major(\\.[[:digit:]]+)?" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

previous_major=`/bin/echo -n "$majors" \
    | { head --lines=2 || exit 1; } \
    | { tail --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
previous=`/bin/echo -n "$versions" \
    | { grep -oE "^$previous_major(\\.[[:digit:]]+)?" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

oldest_major=`/bin/echo -n "$majors" \
    | { head --lines=3 || exit 1; } \
    | { tail --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
oldest=`/bin/echo -n "$versions" \
    | { grep -oE "^$oldest_major(\\.[[:digit:]]+)?" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

snapshot=`{ curl --silent "${url_prefix}/snapshots/" || exit 1; } \
    | { grep -oE "[[:digit:]]+\\.[[:digit:]]+-[[:digit:]]{8}" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

/bin/echo -n "$builtin $current $previous $oldest $snapshot"
