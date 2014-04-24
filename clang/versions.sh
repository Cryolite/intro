#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 50d5b8e7-3976-4386-9158-da16b8b0d5fb "$intro_root/clang/versions.sh"

set -e

urls=('http://llvm.org/releases/download.html')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq 'Download LLVM [[:digit:]]+\.[[:digit:]]+'; then
  versions=`echo "$versions" | grep -Eo 'Download LLVM [[:digit:]]+\.[[:digit:]]+'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+'`
fi

local_versions=`cd "$intro_root" && ls -1 llvm-*/README.txt 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^llvm-[[:digit:]]+\.[[:digit:]]+/README.txt$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n`
echo -n $versions
