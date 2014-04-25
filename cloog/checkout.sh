#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 5a382e76-5269-43f1-b00f-c2b14887259f "$intro_root/cloog/checkout.sh"

PS4='+$0:$LINENO: '
set -ex

[ $# -eq 0 ]

timestamp=528457b5-9e38-4c8f-ac97-fbdb3ccfdbe9
timestamp_path="$intro_root/cloog-trunk/$timestamp"

if [ -e "$intro_root/cloog-trunk" ]; then
  if [ -f "$timestamp_path" ]; then
    ( cd "$intro_root/cloog-trunk" && [ `pwd` = `git rev-parse --show-toplevel` ] )
    ( cd "$intro_root/cloog-trunk" && git clean -ffdx )
  else
    rm -r "$intro_root/cloog-trunk"
  fi
fi

cleanup ()
{
  if [ -e "$intro_root/cloog-trunk" ]; then
    [ -d "$intro_root/cloog-trunk" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    rm -r "$intro_root/cloog-trunk"
  fi
}
trap cleanup ERR HUP INT QUIT TERM

if [ '!' -e "$intro_root/cloog-trunk" ]; then
  ( cd "$intro_root" && git clone 'git://repo.or.cz/cloog.git' cloog-trunk )
fi
( cd "$intro_root/cloog-trunk" && [ `pwd` = `git rev-parse --show-toplevel` ] )

( cd "$intro_root/cloog-trunk" && git pull --ff-only )

( cd "$intro_root/cloog-trunk" && ./autogen.sh )

last_commit_date=`cd "$intro_root/cloog-trunk" && LANG=C git log -1 --date=iso | grep -E '^Date:' | sed -e 's/^Date:[[:space:]]*\(.*\)$/\1/'`
find "$intro_root/cloog-trunk" -execdir touch --date="$last_commit_date" '{}' \+
touch --date="$last_commit_date" "$timestamp_path"
