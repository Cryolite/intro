#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 70b0f28a-6a33-46ca-9d33-50fc26299347 "$intro_root/gdb/latest.sh"

set -e

urls=('http://ftp.jaist.ac.jp/pub/GNU/gdb/'
      'http://ftp.nara.wide.ad.jp/pub/GNU/gnu/gdb/'
      'http://www.ring.gr.jp/archives/GNU/gdb/'
      'ftp://ftp.gnu.org/gnu/gdb/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq 'gdb-[[:digit:]]+(\.[[:digit:]]+){1,2}\.tar\.((gz)|(bz2))'; then
  versions=`echo "$versions" | grep -Eo 'gdb-[[:digit:]]+(\.[[:digit:]]+){1,2}\.tar\.((gz)|(bz2))'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){1,2}'`
fi

local_versions=`cd "$intro_root" && ls -1 gdb-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^gdb-[[:digit:]]+(\.[[:digit:]]+){1,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){1,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
