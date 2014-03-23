#!/usr/bin/env bash

PS4='+binutils/checkout.sh:$LINENO: '
set -ex

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 5f91cd3a-6dac-42fe-bfbb-fe637ee880a4 "$intro_root_dir/binutils/checkout.sh"

[ $# -eq 0 ]

if [ -e "$intro_root_dir/binutils-trunk" ]; then
  [ -d "$intro_root_dir/binutils-trunk/.git" ]
  ( cd "$intro_root_dir/binutils-trunk" && git clean -ffdx )
fi

cleanup ()
{
  rm -rf "$intro_root_dir/binutils-trunk"
}
trap cleanup ERR HUP INT QUIT TERM

if [ '!' -e "$intro_root_dir/binutils-trunk" ]; then
  ( cd "$intro_root_dir" && git clone 'git://sourceware.org/git/binutils-gdb.git' binutils-trunk )
fi

[ -d "$intro_root_dir/binutils-trunk/.git" ]

( cd "$intro_root_dir/binutils-trunk" && git pull --ff-only )

timestamp="$intro_root_dir/binutils-trunk/cd9de9b7-e312-49f1-b2a5-24cd4f322ed5"

last_commit_date=`cd "$intro_root_dir/binutils-trunk" && LANG=C git log -1 --date=iso | grep -E '^Date:' | sed -e 's/^Date:[[:space:]]*\(.*\)$/\1/'`
find "$intro_root_dir/binutils-trunk" -execdir touch --date="$last_commit_date" '{}' \+
touch --date="$last_commit_date" "$timestamp"
