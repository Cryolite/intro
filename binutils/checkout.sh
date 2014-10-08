#!/usr/bin/env bash

PS4='+binutils/checkout.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq 5f91cd3a-6dac-42fe-bfbb-fe637ee880a4 "$intro_root/binutils/checkout.sh"

[ $# -eq 0 ]

( cd "$intro_root" && "$intro_root/util/git-checkout.sh" \
    --url 'git://sourceware.org/git/binutils-gdb.git'    \
    --srcdir binutils-trunk                              \
    --timestamp cd9de9b7-e312-49f1-b2a5-24cd4f322ed5 )
