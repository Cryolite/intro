#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; pwd)`
grep -Fq c20aed5f-b2d1-4ea8-af24-37acb51a17ec "$intro_root_dir/gcc-release-versions.sh"

versions=`curl --silent 'http://{core.ring.gr.jp/pub/lang/egcs,ftp.dti.ad.jp/pub/lang/gcc,ftp.tsukuba.wide.ad.jp/software/gcc}/{releases,snapshots}/' || true`
versions=`echo "$versions" | grep -Eo '((gcc-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+)|([[:digit:]]+\.[[:digit:]]+(\.0-RC)?-[[:digit:]]{8}))'`
versions=`echo "$versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+((\.[[:digit:]]+)|((\.0-RC)?-[[:digit:]]{8}))'`

local_versions=`cd "$intro_root_dir" && echo gcc-*/README`
if [ -n "$local_versions" ]; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+((\.[[:digit:]]+)|((\.0-RC)?-[[:digit:]]{8}))'`
  versions=`echo -e "$versions"'\n'"$local_versions"`
fi

versions=`echo "$versions" | sort -u`
echo -n $versions
