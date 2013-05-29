#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq c6f45da9-000c-41fb-876d-f4d7f1381b4b "$intro_root_dir/openmpi/latest.sh"

urls=('http://www.open-mpi.org/software/')
timeout=30

tempdir=`mktemp -d`
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
  curl -L -m $timeout -o `mktemp --tmpdir="$tempdir"` -s "$url" &
done
wait

versions=`cat "$tempdir"/*`
rm -r "$tempdir"
if echo "$versions" | grep -Eq 'openmpi-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'; then
  versions=`echo "$versions" | grep -Eo 'openmpi-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'`
  versions=`echo "$versions" | grep -Eo 'openmpi-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root_dir" && ls -1 openmpi-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^openmpi-[[:digit:]]+(\.[[:digit:]]+){0,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
