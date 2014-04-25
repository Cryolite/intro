#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq b237e33e-8de8-4a5d-9c6d-70e6b0aee38a "$intro_root/gmp/latest.sh"

set -e

urls=('http://ftp.jaist.ac.jp/pub/GNU/gmp/'
      'http://ftp.tsukuba.wide.ad.jp/software/gmp/'
      'http://ftp.nara.wide.ad.jp/pub/GNU/gnu/gmp/'
      'http://www.ring.gr.jp/archives/GNU/gmp/'
      'ftp://ftp.gnu.org/gnu/gmp/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq 'gmp-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'; then
  versions=`echo "$versions" | grep -Eo 'gmp-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'`
  versions=`echo "$versions" | grep -Eo 'gmp-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root" && ls -1 gmp-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^gmp-[[:digit:]]+(\.[[:digit:]]+){0,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
