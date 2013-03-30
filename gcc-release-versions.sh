#!/usr/bin/env bash

t=`mktemp` || exit 1
curl --max-time 30 --retry 2 --silent 'http://{core.ring.gr.jp/pub/lang/egcs,ftp.dti.ad.jp/pub/lang/gcc,ftp.tsukuba.wide.ad.jp/software/gcc}/{releases,snapshots}/' > "${t}" || { rm "${t}"; exit 1; }
versions=`{ grep -Eo '((gcc-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+)|([[:digit:]]+\.[[:digit:]]+(\.0-RC)?-[[:digit:]]{8}))' "${t}" || exit 1; } \
            | { grep -Eo '[[:digit:]]+\.[[:digit:]]+((\.[[:digit:]]+)|((\.0-RC)?-[[:digit:]]{8}))' || exit 1; }                                  \
            | { sort -u || exit 1; }` || { rm "${t}"; exit 1; }
echo -n $versions
rm "${t}"
