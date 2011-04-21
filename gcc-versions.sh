#!/usr/bin/env sh

url='http://core.ring.gr.jp/pub/GNU/gcc/'
#url='http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/'

versions=`{ wget --quiet --output-document=- -- "$url" || exit 1; } \
    | { grep -oE 'gcc-[[:digit:]]+(\.[[:digit:]]+){1,2}/' || exit 1; } \
    | { grep -oE '[[:digit:]]+(\.[[:digit:]]+){1,2}' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; }`

majors=`/bin/echo -n "$versions" \
    | { grep -oE '^[[:digit:]]+\.[[:digit:]]+' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=4 || exit 1; }`

current_major=`/bin/echo -n "$majors" \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
current=`/bin/echo -n "$versions" \
    | { grep -oE "^$current_major(\.[[:digit:]]+)?" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

previous_major=`/bin/echo -n "$majors" \
    | { head --lines=2 || exit 1; } \
    | { tail --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
previous=`/bin/echo -n "$versions" \
    | { grep -oE "^$previous_major(\.[[:digit:]]+)?" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

older_major=`/bin/echo -n "$majors" \
    | { head --lines=3 || exit 1; } \
    | { tail --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
older=`/bin/echo -n "$versions" \
    | { grep -oE "^$older_major(\.[[:digit:]]+)?" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

oldest_major=`/bin/echo -n "$majors" \
    | { head --lines=4 || exit 1; } \
    | { tail --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
oldest=`/bin/echo -n "$versions" \
    | { grep -oE "^$oldest_major(\.[[:digit:]]+)?" || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=1 || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

versions=`/bin/echo -n "$versions" \
    | { grep -Fv "$current" || exit 1; } \
    | { grep -Fv "$previous" || exit 1; } \
    | { grep -Fv "$older" || exit 1; } \
    | { grep -Fv "$oldest" || exit 1; } \
    | { tr '\n' ' ' || exit 1; } \
    | { sed -e 's/^\(.*\) $/\1/' || exit 1; }`

/bin/echo -n "$current $previous $older $oldest $versions"
