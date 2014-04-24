#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 5f91cd3a-6dac-42fe-bfbb-fe637ee880a4 "$intro_root/binutils/checkout.sh"

PS4='+$0:$LINENO: '
set -ex

[ $# -eq 0 ]

if [ -e "$intro_root/binutils-trunk" ]; then
  [ -d "$intro_root/binutils-trunk/.git" ]
  ( cd "$intro_root/binutils-trunk" && git clean -ffdx )
fi

cleanup ()
{
  rm -rf "$intro_root/binutils-trunk"
}
trap cleanup ERR HUP INT QUIT TERM

if [ '!' -e "$intro_root/binutils-trunk" ]; then
  ( cd "$intro_root" && git clone 'git://sourceware.org/git/binutils-gdb.git' binutils-trunk )
fi

[ -d "$intro_root/binutils-trunk/.git" ]

( cd "$intro_root/binutils-trunk" && git pull --ff-only )

timestamp="$intro_root/binutils-trunk/cd9de9b7-e312-49f1-b2a5-24cd4f322ed5"

last_commit_date=`cd "$intro_root/binutils-trunk" && LANG=C git log -1 --date=iso | grep -E '^Date:' | sed -e 's/^Date:[[:space:]]*\(.*\)$/\1/'`
find "$intro_root/binutils-trunk" -execdir touch --date="$last_commit_date" '{}' \+
touch --date="$last_commit_date" "$timestamp"
