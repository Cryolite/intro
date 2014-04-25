#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 36c08c27-a111-466d-858d-848c134305a4 "$intro_root/binutils/download.sh"

PS4='+$0:$LINENO: '
set -ex

[ $# -eq 1 ]

version="$1"
echo "$version" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+(\.[[:digit:]]+)?)?$'

[ '!' -e "$intro_root/binutils-${version}.tar.bz2.bak" ]
if [ -e "$intro_root/binutils-${version}.tar.bz2" ]; then
  if [ -f "$intro_root/binutils-${version}.tar.bz2" ]; then
    mv "$intro_root/binutils-${version}.tar.bz2" "$intro_root/binutils-${version}.tar.bz2.bak"
  else
    rm -r "$intro_root/binutils-${version}.tar.bz2"
  fi
fi
[ '!' -e "$intro_root/binutils-${version}.tar.bz2" ]

timestamp=cd9de9b7-e312-49f1-b2a5-24cd4f322ed5

[ '!' -e "$intro_root/binutils-${version}.bak" ]
if [ -e "$intro_root/binutils-${version}" ]; then
  if [ -f "$intro_root/binutils-${version}/$timestamp" ]; then
    mv "$intro_root/binutils-${version}" "$intro_root/binutils-${version}.bak"
  else
    rm -r "$intro_root/binutils-${version}"
  fi
fi
[ '!' -e "$intro_root/binutils-${version}" ]

cleanup ()
{
  if [ -e "$intro_root/binutils-${version}.tar.bz2" ]; then
    [ -f "$intro_root/binutils-${version}.tar.bz2" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    rm -r "$intro_root/binutils-${version}.tar.bz2"
  fi
  if [ -e "$intro_root/binutils-${version}" ]; then
    [ -d "$intro_root/binutils-${version}" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    rm -r "$intro_root/binutils-${version}"
  fi
  if [ -e "$intro_root/binutils-${version}.tar.bz2.bak" ]; then
    [ -f "$intro_root/binutils-${version}.tar.bz2.bak" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    mv "$intro_root/binutils-${version}.tar.bz2.bak" "$intro_root/binutils-${version}.tar.bz2"
  fi
  if [ -e "$intro_root/binutils-${version}.bak" ]; then
    [ -f "$intro_root/binutils-${version}.bak/$timestamp" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    mv "$intro_root/binutils-${version}.bak" "$intro_root/binutils-${version}"
  fi
}
trap cleanup ERR HUP INT QUIT TERM

tarball=
if [ -e "$intro_root/binutils-${version}.tar.bz2.bak" ]; then
  [ -f "$intro_root/binutils-${version}.tar.bz2.bak" ]
  tarball="$intro_root/binutils-${version}.tar.bz2.bak"
else
  urls=("http://ftp.jaist.ac.jp/pub/GNU/binutils/binutils-${version}.tar.bz2"
        "http://ftp.nara.wide.ad.jp/pub/GNU/gnu/binutils/binutils-${version}.tar.bz2"
        "http://ftp.tsukuba.wide.ad.jp/software/binutils/binutils-${version}.tar.bz2"
        "http://www.ring.gr.jp/archives/GNU/binutils/binutils-${version}.tar.bz2"
        "ftp://sourceware.org/pub/binutils/snapshots/binutils-${version}.tar.bz2")
  for url in "${urls[@]}"; do
    ( cd "$intro_root" && wget --quiet -- "$url" ) && break
  done
  tarball="$intro_root/binutils-${version}.tar.bz2"
fi
[ -f "$intro_root/binutils-${version}.tar.bz2.bak" -o -f "$intro_root/binutils-${version}.tar.bz2" ]
[ '!' '(' -f "$intro_root/binutils-${version}.tar.bz2.bak" -a -f "$intro_root/binutils-${version}.tar.bz2" ')' ]
[ -f "$tarball" ]

old_timestamp_path="$intro_root/binutils-${version}.bak/$timestamp"

srcdir=
if [ -e "$old_timestamp_path" ]; then
  [ -f "$old_timestamp_path" ]
  if [ "$tarball" -nt "$old_timestamp_path" ]; then
    tar -xjf "$tarball" --directory="$intro_root"
    srcdir="$intro_root/binutils-${version}"
  else
    srcdir="$intro_root/binutils-${version}.bak"
  fi
else
  tar -xjf "$tarball" --directory="$intro_root"
  srcdir="$intro_root/binutils-${version}"
fi
[ -d "$srcdir" ]

new_timestamp_path="$srcdir/$timestamp"

if [ -e "$new_timestamp_path" ]; then
  [ "$srcdir" = "$intro_root/binutils-${version}.bak" ]
  [ -f "$new_timestamp_path" ]
  [ '!' "$tarball" -nt "$new_timestamp_path" ]
else
  [ "$srcdir" = "$intro_root/binutils-${version}" ]
  touch "$new_timestamp_path"
  find "$srcdir" -newer "$tarball" -execdir touch --reference="$tarball" '{}' '+'
  find "$srcdir" -print0 | xargs -0 -L 1 bash -c '[ "$1" -ot "$0" ] && touch --reference="$1" "$0"; true' "$new_timestamp_path"
  find "$srcdir" -print0 | xargs -0 -L 1 bash -c '[ "$1" -nt "$0" ] && touch --reference="$1" "$0"; true' "$new_timestamp_path"
fi

if [ "$tarball" = "$intro_root/binutils-${version}.tar.bz2.bak" ]; then
  [ '!' -e "$intro_root/binutils-${version}.tar.bz2" ]
  mv "$intro_root/binutils-${version}.tar.bz2.bak" "$intro_root/binutils-${version}.tar.bz2"
fi

if [ "$srcdir" = "$intro_root/binutils-${version}.bak" ]; then
  [ '!' -e "$intro_root/binutils-${version}" ]
  mv "$intro_root/binutils-${version}.bak" "$intro_root/binutils-${version}"
fi

if [ -e "$intro_root/binutils-${version}.tar.bz2.bak" ]; then
  [ -f "$intro_root/binutils-${version}.tar.bz2.bak" ] || {
    echo 'warning: a logic error in commit process, forced to proceed' >&2;
  }
  rm -r "$intro_root/binutils-${version}.tar.bz2.bak"
fi

if [ -e "$intro_root/binutils-${version}.bak" ]; then
  [ -d "$intro_root/binutils-${version}.bak" ] || {
    echo 'warning: a logic error in commit process, forced to proceed' >&2;
  }
  rm -r "$intro_root/binutils-${version}.bak"
fi
