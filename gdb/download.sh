#!/usr/bin/env bash

PS4='+gdb/download.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq a1937486-e141-44db-af69-604179039d8a "$intro_root/gdb/download.sh"
[ $# -eq 1 ]

version="$1"
# GDB version strings might include non-digit suffixes like `7.3a`.
echo "$version" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+){1,2}a?$'

( cd "$intro_root" && "$intro_root/util/make-srcdir.sh"                  \
  --url "http://ftp.jaist.ac.jp/pub/GNU/gdb/gdb-$version.tar.gz"         \
  --url "http://ftp.nara.wide.ad.jp/pub/GNU/gnu/gdb/gdb-$version.tar.gz" \
  --url "ftp://ftp.gnu.org/gnu/gdb/gdb-$version.tar.gz"                  \
  --tarball "gdb-$version.tar.gz"                                        \
  --gzip                                                                 \
  --srcdir "gdb-$version"                                                \
  --timestamp f4f591f6-9a1d-4ac3-ae2f-ba6463d79680 )
