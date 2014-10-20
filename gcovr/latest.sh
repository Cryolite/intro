#!/usr/bin/env bash

set -e

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq 020a9f0b-6a09-47f4-9137-4941a7374ef2 "$intro_root/gcovr/latest.sh"

if [ -d "$intro_root/gcovr-trunk" ]; then
    (cd "$intro_root/gcovr-trunk"                            \
        && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
        && [ -f fb301e39-8f74-4e35-8428-9b3b48a324bc ])
fi
(cd "$intro_root" && gcovr/checkout.sh >/dev/null 2>&1)
(cd "$intro_root/gcovr-trunk"                            \
    && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
    && [ -f fb301e39-8f74-4e35-8428-9b3b48a324bc ])

tags="$(cd "$intro_root/gcovr-trunk" && git tag)"
echo "$tags" | grep -Eq '^[[:digit:]]+\.[[:digit:]]+$'
versions="$(echo "$tags" | grep -Eo '^[[:digit:]]+\.[[:digit:]]+$')"

local_versions="$(cd "$intro_root" && ls -1 gcovr-*/fb301e39-8f74-4e35-8428-9b3b48a324bc 2>/dev/null || true)"
if echo "$local_versions" | grep -Eq '^gcovr-[[:digit:]]+\.[[:digit:]]+/fb301e39-8f74-4e35-8428-9b3b48a324bc$'; then
    local_versions="$(echo "$local_versions" | grep -Eo '^gcovr-[[:digit:]]+\.[[:digit:]]+/')"
    local_versions="$(echo "$local_versions" | grep -Eo '[[:digit:]]+\.[[:digit:]]+')"
    versions="$(echo -e ${versions:+"$versions"\\n}"$local_versions")"
fi

[ -n "$versions" ]
versions="$(echo "$versions" | sort -V -u)"
latest_version=$(echo "$versions" | tail -n 1)
echo -n $latest_version
