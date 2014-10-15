#!/usr/bin/env bash

PS4='+cradle/checkout.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq af8f9583-9265-444d-a847-ec5630f5894b "$intro_root/cradle/checkout.sh"

[ $# -eq 0 ]

(cd "$intro_root" && "$intro_root/util/git-checkout.sh"    \
    --url 'https://github.com/Cryolite/cradle.git'         \
    --srcdir cradle-trunk                                  \
    --timestamp ec4b02af-dcb1-45fe-9f8f-00930cb82c14)
