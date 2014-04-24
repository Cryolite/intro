#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq b0d8a1f6-cbc3-4e9e-859a-b5bb9f59028f "$intro_root/binutils/latest.sh"

set -e

urls=('http://ftp.jaist.ac.jp/pub/GNU/binutils/'
      'http://ftp.nara.wide.ad.jp/pub/GNU/gnu/binutils/'
      'http://ftp.tsukuba.wide.ad.jp/software/binutils/'
      'http://www.ring.gr.jp/archives/GNU/binutils/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq 'binutils-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'; then
  versions=`echo "$versions" | grep -Eo 'binutils-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'`
  versions=`echo "$versions" | grep -Eo 'binutils-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root" && ls -1 binutils-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^binutils-[[:digit:]]+(\.[[:digit:]]+){0,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
