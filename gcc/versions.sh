#!/usr/bin/env bash

set -e

intro_root="$(cd "$(dirname "$0")"; pwd)"
grep -Fq c20aed5f-b2d1-4ea8-af24-37acb51a17ec "$intro_root/gcc/versions.sh"

urls=(http://{ftp.kddilabs.jp/gnusoftware/gcc.gnu.org/gcc,ftp.tsukuba.wide.ad.jp/software/gcc,core.ring.gr.jp/pub/lang/egcs}/{releases,snapshots}/)
timeout=30

tempdir="$(mktemp -d)"
trap 'rm -rf "$tempdir"' ERR HUP INT TERM QUIT

for url in "${urls[@]}"; do
    curl -m $timeout -o "$(mktemp --tmpdir="$tempdir")" -s "$url" &
done
wait

versions="$(cat "$tempdir"/*)"
rm -r "$tempdir"

if echo "$versions" | grep -Eq '(gcc-[[:digit:]]+(\.[[:digit:]]+){2})|([[:digit:]]+(\.[[:digit:]]+)?-[[:digit:]]{8})|([[:digit:]]+\.[[:digit:]]+\.0-RC-[[:digit:]]{8})'; then
    versions="$(echo "$versions" | grep -Eo '(gcc-[[:digit:]]+(\.[[:digit:]]+){2})|([[:digit:]]+(\.[[:digit:]]+)?-[[:digit:]]{8})|([[:digit:]]+\.[[:digit:]]+\.0-RC-[[:digit:]]{8})')"
    versions="$(echo "$versions" | grep -Eo '([[:digit:]]+(\.[[:digit:]]+){2})|([[:digit:]]+(\.[[:digit:]]+)?-[[:digit:]]{8})|([[:digit:]]+\.[[:digit:]]+\.0-RC-[[:digit:]]{8})')"
fi

local_versions="$(cd "$intro_root" && ls -1 gcc-*/README 2>/dev/null || true)"
if echo "$local_versions" | grep -Eq '^gcc-(([[:digit:]]+(\.[[:digit:]]+){2})|([[:digit:]]+(\.[[:digit:]]+)?-[[:digit:]]{8})|([[:digit:]]+\.[[:digit:]]+\.0-RC-[[:digit:]]{8}))/README$'; then
    local_versions="$(echo "$local_versions" | grep -Eo '([[:digit:]]+(\.[[:digit:]]+){2})|([[:digit:]]+(\.[[:digit:]]+)?-[[:digit:]]{8})|([[:digit:]]+\.[[:digit:]]+\.0-RC-[[:digit:]]{8})')"
    versions="$(echo -e ${versions:+"$versions"'\n'}"$local_versions")"
fi

[ -n "$versions" ]
versions="$(echo "$versions" | sort -u)"
echo -n $versions
