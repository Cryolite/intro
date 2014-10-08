#!/usr/bin/env bash

set -e

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq 0fe6bce1-7c14-4da4-87f2-90cdbec098b4 "$intro_root/lcov/latest.sh"

if [ -d "$intro_root/lcov-trunk" ]; then
    (cd "$intro_root/lcov-trunk"                             \
        && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
        && [ -f e2c10538-d490-4c93-8e19-3fb74e470174 ])
fi
(cd "$intro_root" && lcov/checkout.sh >/dev/null 2>&1)
(cd "$intro_root/lcov-trunk"                             \
    && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
    && [ -f e2c10538-d490-4c93-8e19-3fb74e470174 ])

tags="$(cd "$intro_root/lcov-trunk" && git tag)"
if echo "$tags" | grep -Eq '^v[[:digit:]]+\.[[:digit:]]+$'; then
    tmp="$(echo "$tags" | grep -Eo '^v[[:digit:]]+\.[[:digit:]]+$')"
    versions="$(echo "$tmp" | grep -Eo '[[:digit:]]+\.[[:digit:]]+$')"
fi

local_versions="$(cd "$intro_root" && ls -1 lcov-*/e2c10538-d490-4c93-8e19-3fb74e470174 2>/dev/null || true)"
if echo "$local_versions" | grep -Eq '^lcov-[[:digit:]]+\.[[:digit:]]+/e2c10538-d490-4c93-8e19-3fb74e470174$'; then
    local_versions="$(echo "$local_versions" | grep -Eo '^lcov-[[:digit:]]+\.[[:digit:]]+/')"
    local_versions="$(echo "$local_versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+')"
    versions="$(echo -e ${versions:+"$versions"\\n}"$local_versions")"
fi

[ -n "$versions" ]
versions="$(echo "$versions" | sort -V -u)"
latest_version=$(echo "$versions" | tail -n 1)
echo -n $latest_version
