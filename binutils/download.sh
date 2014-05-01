#!/usr/bin/env bash

PS4='+binutils/download.sh:$LINENO: '
set -ex

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 36c08c27-a111-466d-858d-848c134305a4 "$intro_root/binutils/download.sh"

[ $# -eq 1 ]

version="$1"
echo "$version" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+(\.[[:digit:]]+)?)?$'

( cd "$intro_root" && "$intro_root/util/make-srcdir.sh"                               \
  --url "http://ftp.jaist.ac.jp/pub/GNU/binutils/binutils-${version}.tar.bz2"         \
  --url "http://ftp.nara.wide.ad.jp/pub/GNU/gnu/binutils/binutils-${version}.tar.bz2" \
  --url "http://ftp.tsukuba.wide.ad.jp/software/binutils/binutils-${version}.tar.bz2" \
  --url "http://www.ring.gr.jp/archives/GNU/binutils/binutils-${version}.tar.bz2"     \
  --url "ftp://sourceware.org/pub/binutils/snapshots/binutils-${version}.tar.bz2"     \
  --tarball "binutils-${version}.tar.bz2"                                             \
  --bzip2                                                                             \
  --srcdir "binutils-${version}"                                                      \
  --timestamp cd9de9b7-e312-49f1-b2a5-24cd4f322ed5 )
