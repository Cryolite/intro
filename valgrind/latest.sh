#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq b25d5fb0-c3dc-4380-ad46-63ebb625480c "$intro_root_dir/valgrind/latest.sh"

urls=('http://valgrind.org/downloads/current.html')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq 'valgrind-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.bz2'; then
  versions=`echo "$versions" | grep -Eo 'valgrind-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.bz2'`
  versions=`echo "$versions" | grep -Eo 'valgrind-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root_dir" && ls -1 valgrind-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^valgrind-[[:digit:]]+(\.[[:digit:]]+){0,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
