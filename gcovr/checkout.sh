#!/usr/bin/env bash

PS4='+gcovr/checkout.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq c866f004-83df-4d02-8317-05ddfdd8bc1c "$intro_root/gcovr/checkout.sh"

[ $# -eq 0 ]

(cd "$intro_root" && "$intro_root/util/git-checkout.sh" \
    --url 'https://github.com/gcovr/gcovr.git'          \
    --srcdir gcovr-trunk                                \
    --timestamp fb301e39-8f74-4e35-8428-9b3b48a324bc)
