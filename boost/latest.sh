#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq fc2dbd90-33e2-4684-b0f9-15fcf98c5918 "$intro_root/boost/latest.sh"

set -e

urls=('http://www.boost.org/users/history/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq '>Version [[:digit:]]+(\.[[:digit:]]+){0,2}<'; then
  versions=`echo "$versions" | grep -Eo '>Version [[:digit:]]+(\.[[:digit:]]+){0,2}<'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
