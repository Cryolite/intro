#!/usr/bin/env bash

PS4='+lcov/download.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq 39422c70-fc14-4a31-a6e9-3a6ffc7d903a "$intro_root/lcov/download.sh"

[ $# -eq 1 ]

version="$1"
echo "$version" | grep -Eq '^[[:digit:]]+\.[[:digit:]]+$'

if [ -d "$intro_root/lcov-trunk" ]; then
    (cd "$intro_root/lcov-trunk"                             \
        && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
        && [ -f e2c10538-d490-4c93-8e19-3fb74e470174 ])
fi
(cd "$intro_root" && lcov/checkout.sh)
(cd "$intro_root/lcov-trunk"                             \
    && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
    && [ -f e2c10538-d490-4c93-8e19-3fb74e470174 ])

(cd "$intro_root/lcov-trunk" && { git tag | grep -Eq "^v$version\$"; })

srcdir_path="$intro_root/lcov-$version"
timestamp_basename=e2c10538-d490-4c93-8e19-3fb74e470174
timestamp_path="$srcdir_path/$timestamp_basename"

cleanup ()
{
    rm -rf "$srcdir_path"
}

if [ '!' -f "$timestamp_path" ]; then
    if [ -e "$srcdir_path" ]; then
        rm -rf "$srcdir_path"
    fi

    trap cleanup ERR HUP INT QUIT TERM

    [ '!' -e "$srcdir_path" ]
    (cd "$intro_root/lcov-trunk" \
        && git archive --prefix="lcov-$version/" "refs/tags/v$version" | tar -x -C "$intro_root")

    tag_commit_date="$(cd "$intro_root/lcov-trunk" && LANG=C git log -1 --date=iso "refs/tags/v$version")"
    tag_commit_date="$(echo "$tag_commit_date" | grep -E '^Date:')"
    if [ "$(echo "$tag_commit_date" | wc -l)" -ne 1 ]; then
        echo "lcov/download.sh: error: failed to extract the date of the tag" >&2
        exit 1
    fi
    tag_commit_date="$(echo "$tag_commit_date" | sed -e 's/^Date:[[:space:]]*\(.*\)$/\1/')"
    if echo "$tag_commit_date" | grep -Eq '^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2} [+-][[:digit:]]{4}$'; then
        :
    else
        echo "lcov/download.sh: error: failed to extract the date of the tag" >&2
        exit 1
    fi

    [ '!' -f "$timestamp_path" ]
    touch --date="$tag_commit_date" "$timestamp_path"
    find "$srcdir_path" -newer "$timestamp_path" -execdir touch --date="$tag_commit_date" '{}' '+'

    trap - ERR HUP INT QUIT TERM
fi
[ -f "$timestamp_path" ]
