#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq f4ba5b1e-7039-4aac-a553-a739f6a20b49 "$intro_root_dir/cloog/latest.sh"

urls=('http://www.bastoul.net/cloog/pages/download/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq 'cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'; then
  versions=`echo "$versions" | grep -Eo 'cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'`
  versions=`echo "$versions" | grep -Eo 'cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root_dir" && ls -1 cloog-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
