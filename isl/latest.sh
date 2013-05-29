#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq b3dd7826-a9ca-4a44-a951-788b5661ab27 "$intro_root_dir/isl/latest.sh"

if [ ! -e "$intro_root_dir/isl-trunk/.git" ]; then
  ( cd "$intro_root_dir" && rm -rf isl-trunk )
fi

# Checks whether ISL repository has been cloned into
# `$intro_root_dir/isl-trunk`. Note that
# `[ ! -d "$intro_root_dir/isl-trunk" ]` cannot be used because `bjam` might
# automatically create `$intro_root_dir/isl-trunk` directory.
if [ ! -e "$intro_root_dir/isl-trunk/.git" ]; then
  ( cd "$intro_root_dir" && git clone -q 'http://repo.or.cz/r/isl.git' isl-trunk 2>/dev/null || true )
else
  ( cd "$intro_root_dir/isl-trunk" && git clean -ffdxq )
  ( cd "$intro_root_dir/isl-trunk" && git pull --ff-only -q 2>/dev/null || true )
fi

if [ -d "$intro_root_dir/isl-trunk/.git" ]; then
  versions=`cd "$intro_root_dir/isl-trunk" && git tag`
  versions=`echo "$versions" | grep -Eo '^isl-[[:digit:]]+(\.[[:digit:]]+){0,2}$'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root_dir" && ls -1 isl-*/ChangeLog 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^isl-[[:digit:]]+(\.[[:digit:]]+){0,2}/ChangeLog$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
