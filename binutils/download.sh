#!/usr/bin/env bash

PS4='+binutils/download.sh:$LINENO: '
set -ex

intro_root_dir=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 36c08c27-a111-466d-858d-848c134305a4 "$intro_root_dir/binutils/download.sh"

[ $# -eq 1 ]

version="$1"
if [ "$version" = latest ]; then
  version=`"$intro_root_dir/binutils/latest.sh"`
fi
if echo "$version" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+(\.[[:digit:]]+)?)?$'; then
  :
else
  exit 1
fi

[ '!' -e "$intro_root_dir/binutils-${version}.tar.bz2.bak" ]
if [ -e "$intro_root_dir/binutils-${version}.tar.bz2" ]; then
  mv "$intro_root_dir/binutils-${version}.tar.bz2" "$intro_root_dir/binutils-${version}.tar.bz2.bak"
fi

[ '!' -e "$intro_root_dir/binutils-${version}.bak" ]
if [ -e "$intro_root_dir/binutils-${version}" ]; then
  mv "$intro_root_dir/binutils-${version}" "$intro_root_dir/binutils-${version}.bak"
fi

cleanup ()
{
  rm -f "$intro_root_dir/binutils-${version}.tar.bz2"
  rm -rf "$intro_root_dir/binutils-${version}"
  if [ -e "$intro_root_dir/binutils-${version}.tar.bz2.bak" ]; then
    mv "$intro_root_dir/binutils-${version}.tar.bz2.bak" "$intro_root_dir/binutils-${version}.tar.bz2"
  fi
  if [ -e "$intro_root_dir/binutils-${version}.bak" ]; then
    mv "$intro_root_dir/binutils-${version}.bak" "$intro_root_dir/binutils-${version}"
  fi
}
trap cleanup ERR HUP INT QUIT TERM

tarball=
if [ -e "$intro_root_dir/binutils-${version}.tar.bz2.bak" ]; then
  [ -f "$intro_root_dir/binutils-${version}.tar.bz2.bak" ]
  tarball="$intro_root_dir/binutils-${version}.tar.bz2.bak"
else
  urls=("http://ftp.jaist.ac.jp/pub/GNU/binutils/binutils-${version}.tar.bz2"
        "http://ftp.nara.wide.ad.jp/pub/GNU/gnu/binutils/binutils-${version}.tar.bz2"
        "http://ftp.tsukuba.wide.ad.jp/software/binutils/binutils-${version}.tar.bz2"
        "http://www.ring.gr.jp/archives/GNU/binutils/binutils-${version}.tar.bz2"
        "ftp://sourceware.org/pub/binutils/snapshots/binutils-${version}.tar.bz2")
  for url in "${urls[@]}"; do
    ( cd "$intro_root_dir" && wget --quiet -- "$url" ) && break
  done
  tarball="$intro_root_dir/binutils-${version}.tar.bz2"
fi

[ -f "$intro_root_dir/binutils-${version}.tar.bz2.bak" -o -f "$intro_root_dir/binutils-${version}.tar.bz2" ]
[ '!' '(' -f "$intro_root_dir/binutils-${version}.tar.bz2.bak" -a -f "$intro_root_dir/binutils-${version}.tar.bz2" ')' ]
[ -f "$tarball" ]

old_timestamp="$intro_root_dir/binutils-${version}.bak/cd9de9b7-e312-49f1-b2a5-24cd4f322ed5"

srcdir=
if [ -e "$old_timestamp" ]; then
  [ -f "$old_timestamp" ]
  if [ "$tarball" -nt "$old_timestamp" ]; then
    tar -xjf "$tarball" --directory="$intro_root_dir"
    srcdir="$intro_root_dir/binutils-${version}"
  else
    srcdir="$intro_root_dir/binutils-${version}.bak"
  fi
else
  tar -xjf "$tarball" --directory="$intro_root_dir"
  srcdir="$intro_root_dir/binutils-${version}"
fi

[ -d "$srcdir" ]

timestamp="$srcdir/cd9de9b7-e312-49f1-b2a5-24cd4f322ed5"

if [ -e "$timestamp" ]; then
  [ "$srcdir" = "$intro_root_dir/binutils-${version}.bak" ]
  [ -f "$timestamp" ]
  [ '!' "$tarball" -nt "$timestamp" ]
else
  [ "$srcdir" = "$intro_root_dir/binutils-${version}" ]
  touch "$timestamp"
  find "$srcdir" -newer "$tarball" -execdir touch --reference="$tarball" '{}' '+'
  find "$srcdir" -print0 | xargs -0 -L 1 bash -c '[ "$1" -ot "$0" ] && touch --reference="$1" "$0"; true' "$timestamp"
  find "$srcdir" -print0 | xargs -0 -L 1 bash -c '[ "$1" -nt "$0" ] && touch --reference="$1" "$0"; true' "$timestamp"
fi

if [ "$tarball" = "$intro_root_dir/binutils-${version}.tar.bz2.bak" ]; then
  [ '!' -e "$intro_root_dir/binutils-${version}.tar.bz2" ]
  mv "$intro_root_dir/binutils-${version}.tar.bz2.bak" "$intro_root_dir/binutils-${version}.tar.bz2"
fi

if [ "$srcdir" = "$intro_root_dir/binutils-${version}.bak" ]; then
  [ '!' -e "$intro_root_dir/binutils-${version}" ]
  mv "$intro_root_dir/binutils-${version}.bak" "$intro_root_dir/binutils-${version}"
fi

if [ -e "$intro_root_dir/binutils-${version}.tar.bz2.bak" ]; then
  rm -f "$intro_root_dir/binutils-${version}.tar.bz2.bak"
fi

if [ -e "$intro_root_dir/binutils-${version}.bak" ]; then
  rm -rf "$intro_root_dir/binutils-${version}.bak"
fi
