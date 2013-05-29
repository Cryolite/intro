#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq d82d986b-afb9-49bb-806d-d7d7c60d3853 "$intro_root_dir/icu4c/latest.sh"

urls=('http://site.icu-project.org/download')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -F 'ICU4C' | grep -Eq '>[[:digit:]]+(\.[[:digit:]]+){0,3}<'; then
  versions=`echo "$versions" | grep -F 'ICU4C'`
  versions=`echo "$versions" | grep -Eo '>[[:digit:]]+(\.[[:digit:]]+){0,3}<'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,3}'`
fi

local_versions=`cd "$intro_root_dir" && ls -1 icu-*/readme.html 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^icu-[[:digit:]]+(\.[[:digit:]]+){0,3}/readme\.html$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,3}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
