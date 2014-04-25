#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 2586f6f7-d8c6-4d9d-8186-d038833f24dc "$intro_root/ppl/latest.sh"

set -e

urls=('http://bugseng.com/products/ppl/download/ftp/releases/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq '>[[:digit:]]+(\.[[:digit:]]+){0,2}/'; then
  versions=`echo "$versions" | grep -Eo '>[[:digit:]]+(\.[[:digit:]]+){0,2}/'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root" && ls -1 ppl-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^ppl-[[:digit:]]+(\.[[:digit:]]+){0,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
