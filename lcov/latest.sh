#!/usr/bin/env bash

set -e

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 0fe6bce1-7c14-4da4-87f2-90cdbec098b4 "$intro_root_dir/lcov/latest.sh"

if [ ! -e "$intro_root_dir/lcov-trunk/CVS" ]; then
  cd "$intro_root_dir" && rm -rf lcov-trunk
fi

cvs_status=$?
cvs -d :pserver:anonymous:@ltp.cvs.sourceforge.net:/cvsroot/ltp -Q login >/dev/null 2>&1 || cvs_status=$?
trap 'cvs -d :pserver:anonymous@ltp.cvs.sourceforge.net:/cvsroot/ltp -q logout' ERR HUP INT QUIT TERM

if [ $cvs_status -eq 0 ]; then
  if [ ! -e "$intro_root_dir/lcov-trunk/CVS" ]; then
    ( cd "$intro_root_dir" && cvs -z 3 -d :pserver:anonymous@ltp.cvs.sourceforge.net:/cvsroot/ltp -Q co -d lcov-trunk utils 2>/dev/null || true )
  else
    ( cd "$intro_root_dir/lcov-trunk" && cvs -q update 2>/dev/null || true )
  fi

  if [ -d "$intro_root_dir/lcov-trunk/CVS" ]; then
    versions=`cd "$intro_root_dir/lcov-trunk/analysis/lcov" && cvs -Q status -v README 2>/dev/null || true`
    if echo "$versions" | grep -Eq '[[:space:]]LCOV_[[:digit:]]+_[[:digit:]]+[[:space:]]'; then
      versions=`echo "$versions" | grep -Eo '[[:space:]]LCOV_[[:digit:]]+_[[:digit:]]+[[:space:]]'`
      versions=`echo "$versions" | grep -Eo '[[:digit:]]+_[[:digit:]]+'`
      versions=`echo "$versions" | sed -e 's/_/./'`
    fi
  fi

  cvs -d :pserver:anonymous@ltp.cvs.sourceforge.net:/cvsroot/ltp -q logout
fi

trap - ERR HUP INT QUIT TERM

local_versions=`cd "$intro_root_dir" && ls -1 lcov-*/README 2>/dev/null || true`
if echo "$local_versions" | grep -Eq '^lcov-[[:digit:]]+(\.[[:digit:]]+){0,2}/README$'; then
  local_versions=`echo "$local_versions" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
  versions=`echo -e ${versions:+"$versions"'\n'}"$local_versions"`
fi

[ -n "$versions" ]
versions=`echo "$versions" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n`
latest_version=`echo "$versions" | tail -n 1`
echo -n $latest_version
