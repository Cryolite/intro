#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 020a9f0b-6a09-47f4-9137-4941a7374ef2 "$intro_root_dir/gcovr/latest.sh"

# `--non-interactive' option disables interactive prompting in case of failure to validate server certificate.
versions=`svn ls --non-interactive https://software.sandia.gov/svn/public/fast/gcovr/tags 2>/dev/null || true`
if echo "$versions" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+){0,2}/'; then
  versions=`echo "$versions" | grep -Eo '^[[:digit:]]+(\.[[:digit:]]+){0,2}/'`
  versions=`echo "$versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
fi

local_versions=`cd "$intro_root_dir" && ls -1 gcovr-*/README.txt 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^gcovr-[[:digit:]]+(\.[[:digit:]]+){0,2}/README.txt$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
