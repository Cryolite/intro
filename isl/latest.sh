#!/usr/bin/env bash

set -e

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq b3dd7826-a9ca-4a44-a951-788b5661ab27 "$intro_root/isl/latest.sh"

if [ ! -e "$intro_root/isl-trunk/ChangeLog" ]; then
  ( cd "$intro_root" && rm -rf isl-trunk )
fi

trap "( cd \"$intro_root\" && rm -r isl-trunk )" ERR HUP INT QUIT TERM

# Checks whether ISL repository has been cloned into
# `$intro_root/isl-trunk`. Note that `[ ! -d "$intro_root/isl-trunk" ]`
# cannot be used because `bjam` would automatically create
# `$intro_root/isl-trunk` directory.
if [ ! -e "$intro_root/isl-trunk/ChangeLog" ]; then
  ( cd "$intro_root" && git clone -q 'http://repo.or.cz/r/isl.git' isl-trunk )
  ( cd "$intro_root/isl-trunk" && git clean -ffdxq )
else
  ( cd "$intro_root/isl-trunk" && git clean -ffdxq )
  ( cd "$intro_root/isl-trunk" && git pull --ff-only -q )
fi
[ -f "$intro_root/isl-trunk/ChangeLog" ]

src=`( cd "$intro_root/isl-trunk" && git tag )`
src=`echo "$src" | grep -Eo '^isl-[[:digit:]]+(\.[[:digit:]]+){0,2}$'`
src=`echo "$src" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}$'`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
