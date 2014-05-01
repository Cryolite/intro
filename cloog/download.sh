#!/usr/bin/env bash

PS4='+cloog/download.sh:$LINENO: '
set -ex

intro_root=$(cd "$(dirname "$0")"; cd ..; pwd)
grep -Fq 9ae5da01-d17c-4c4b-a9ec-2d77fd8e496c "$intro_root/cloog/download.sh"

[ $# -eq 1 ]

version="$1"
echo "$version" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+){0,2}$'

( cd "$intro_root" && "$intro_root/util/make-srcdir.sh"                       \
    --url "http://www.bastoul.net/cloog/pages/download/cloog-$version.tar.gz" \
    --tarball "cloog-$version.tar.gz"                                         \
    --gzip                                                                    \
    --srcdir "cloog-$version"                                                 \
    --timestamp 528457b5-9e38-4c8f-ac97-fbdb3ccfdbe9 )
