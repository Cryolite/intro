#!/usr/bin/env sh

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)` || exit 1
[ -e "$intro_root/isl/latest.sh" ] || exit 1

if [ ! -d "$intro_root/isl-trunk" ]; then
    ( cd "$intro_root" && git clone -q 'http://repo.or.cz/r/isl.git' isl-trunk )
    if [ $? -ne 0 ]; then
        ( cd "$intro_root" && rm -rf isl-trunk )
        exit 1
    fi
fi

( cd "$intro_root/isl-trunk" && git pull -q )
if [ $? -ne 0 ]; then
    ( cd "$intro_root" && rm -rf isl-trunk )
    exit 1
fi

src=`( cd "$intro_root/isl-trunk" && git tag )` || exit 1
src=`echo "$src" | grep -Eo '^isl-[[:digit:]]+(\.[[:digit:]]+){0,2}$'` || exit 1
src=`echo "$src" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}$'` || exit 1
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
