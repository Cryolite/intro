#!/usr/bin/env sh

releases_src=`curl --silent "http://{core.ring.gr.jp/pub/lang/egcs,ftp.dti.ad.jp/pub/lang/gcc,ftp.tsukuba.wide.ad.jp/software/gcc}/{releases,snapshots}/" || exit 1`
versions=`{ /bin/echo -n "$releases_src" || exit 1; }                          \
    | { grep -Eo "((gcc-[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+)|([[:digit:]]+\\.[[:digit:]]+(\\.0-RC)?-[[:digit:]]{8}))" || exit 1; } \
    | { grep -Eo "[[:digit:]]+\\.[[:digit:]]+((\\.[[:digit:]]+)|((\\.0-RC)?-[[:digit:]]{8}))" || exit 1; }     \
    | { sort -u || exit 1; }`
echo -n $versions
