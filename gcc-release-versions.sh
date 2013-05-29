#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; pwd)`
grep -Fq c20aed5f-b2d1-4ea8-af24-37acb51a17ec "$intro_root_dir/gcc-release-versions.sh"

urls=(http://{core.ring.gr.jp/pub/lang/egcs,ftp.dti.ad.jp/pub/lang/gcc,ftp.tsukuba.wide.ad.jp/software/gcc}/{releases,snapshots}/)
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq '(gcc-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+)|([[:digit:]]+\.[[:digit:]]+(\.0-RC)?-[[:digit:]]{8})'; then
  versions=`echo "$versions" | grep -Eo '(gcc-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+)|([[:digit:]]+\.[[:digit:]]+(\.0-RC)?-[[:digit:]]{8})'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+((\.[[:digit:]]+)|((\.0-RC)?-[[:digit:]]{8}))'`
fi

local_versions=`cd "$intro_root_dir" && ls -1 gcc-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^gcc-[[:digit:]]+\.[[:digit:]]+((\.[[:digit:]]+)|((\.0-RC)?-[[:digit:]]{8}))/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+((\.[[:digit:]]+)|((\.0-RC)?-[[:digit:]]{8}))'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u`
echo -n $versions
