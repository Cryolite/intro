#!/usr/bin/env bash

PS4='+gmp/download.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq 9a2a7760-8595-4663-81b4-bc7b2e50015f "$intro_root/gmp/download.sh"

[ $# -eq 1 ]

version="$1"
# GMP version strings might include non-digit suffixes like `6.0.0a`.
echo "$version" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+){0,2}a?$'

( cd "$intro_root" && "$intro_root/util/make-srcdir.sh"                     \
  --url "http://ftp.jaist.ac.jp/pub/GNU/gmp/gmp-${version}.tar.bz2"         \
  --url "http://ftp.tsukuba.wide.ad.jp/software/gmp/gmp-${version}.tar.bz2" \
  --url "http://ftp.nara.wide.ad.jp/pub/GNU/gnu/gmp/gmp-${version}.tar.bz2" \
  --url "http://www.ring.gr.jp/archives/GNU/gmp/gmp-${version}.tar.bz2"     \
  --url "ftp://ftp.gnu.org/gnu/gmp/gmp-${version}.tar.bz2"                  \
  --tarball "gmp-${version}.tar.bz2"                                        \
  --bzip2                                                                   \
  --srcdir "gmp-${version}"                                                 \
  --timestamp 2bf4ddbc-6fd0-44c5-82ce-d66a6eb45809 )
