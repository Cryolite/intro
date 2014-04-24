#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 5fa94497-1c30-4bdf-a2d6-43ade94e55db "$intro_root/opencv/latest.sh"

set -e

urls=('http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq '/projects/opencvlibrary/files/opencv-unix/[[:digit:]]+(\.[[:digit:]]+){0,3}/'; then
  versions=`echo "$versions" | grep -Eo '/projects/opencvlibrary/files/opencv-unix/[[:digit:]]+(\.[[:digit:]]+){0,3}/'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,3}'`
fi

local_versions=`cd "$intro_root" && ls -1 opencv-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^opencv-[[:digit:]]+(\.[[:digit:]]+){0,3}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,3}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
