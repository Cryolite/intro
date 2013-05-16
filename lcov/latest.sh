#!/usr/bin/env bash

set -e

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 0fe6bce1-7c14-4da4-87f2-90cdbec098b4 "$intro_root/lcov/latest.sh"

trap "cd \"$intro_root\" && rm -r lcov-trunk" ERR HUP INT QUIT TERM

if [ ! -d "$intro_root/lcov-trunk" ]; then
  cvs -d :pserver:anonymous:@ltp.cvs.sourceforge.net:/cvsroot/ltp -q login
  ( cd "$intro_root" && cvs -z 3 -d :pserver:anonymous@ltp.cvs.sourceforge.net:/cvsroot/ltp -q co -d lcov-trunk utils )
  cvs -d :pserver:anonymous@ltp.cvs.sourceforge.net:/cvsroot/ltp -q logout
fi

( cd "$intro_root/lcov-trunk" && cvs -q update )

src=`cd "$intro_root/lcov-trunk/analysis/lcov" && cvs status -v README`
src=`echo "$src" | grep -Eo '[[:space:]]LCOV_[[:digit:]]+_[[:digit:]]+[[:space:]]'`
src=`echo "$src" | grep -Eo '[[:digit:]]+_[[:digit:]]+'`
echo "$src" | sed -e 's/_/./' | sort -u -t . -k 1,1n -k 2,2n | tail --lines=1 | tr --delete '\n'
