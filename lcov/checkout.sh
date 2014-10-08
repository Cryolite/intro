#!/usr/bin/env bash

PS4='+lcov/checkout.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq 27110019-7358-4b1d-9495-9014dd303142 "$intro_root/lcov/checkout.sh"

[ $# -eq 0 ]

(cd "$intro_root" && "$intro_root/util/git-checkout.sh"    \
    --url 'https://github.com/linux-test-project/lcov.git' \
    --srcdir lcov-trunk                                    \
    --timestamp e2c10538-d490-4c93-8e19-3fb74e470174)
