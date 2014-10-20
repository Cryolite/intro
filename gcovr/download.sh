#!/usr/bin/env bash

PS4='+gcovr/download.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq daa9f568-1871-4b1f-898c-5fd03d9c5e0f "$intro_root/gcovr/download.sh"

[ $# -eq 1 ]

version="$1"
echo "$version" | grep -Eq '^[[:digit:]]+\.[[:digit:]]+$'

if [ -d "$intro_root/gcovr-trunk" ]; then
    (cd "$intro_root/gcovr-trunk"                            \
        && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
        && [ -f fb301e39-8f74-4e35-8428-9b3b48a324bc ])
fi
(cd "$intro_root" && gcovr/checkout.sh)
(cd "$intro_root/gcovr-trunk"                            \
    && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] \
    && [ -f fb301e39-8f74-4e35-8428-9b3b48a324bc ])

(cd "$intro_root/gcovr-trunk" && { git tag | grep -Eq "^$version\$"; })

srcdir_path="$intro_root/gcovr-$version"
timestamp_basename=fb301e39-8f74-4e35-8428-9b3b48a324bc
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
    (cd "$intro_root/gcovr-trunk" \
        && git archive --prefix="gcovr-$version/" "refs/tags/$version" | tar -x -C "$intro_root")

    tag_commit_date="$(cd "$intro_root/gcovr-trunk" && LANG=C git log -1 --date=iso "refs/tags/$version")"
    tag_commit_date="$(echo "$tag_commit_date" | grep -E '^Date:')"
    if [ "$(echo "$tag_commit_date" | wc -l)" -ne 1 ]; then
        echo "gcovr/download.sh: error: failed to extract the date of the tag" >&2
        exit 1
    fi
    tag_commit_date="$(echo "$tag_commit_date" | sed -e 's/^Date:[[:space:]]*\(.*\)$/\1/')"
    if echo "$tag_commit_date" | grep -Eq '^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2} [+-][[:digit:]]{4}$'; then
        :
    else
        echo "gcovr/download.sh: error: failed to extract the date of the tag" >&2
        exit 1
    fi

    [ '!' -f "$timestamp_path" ]
    touch --date="$tag_commit_date" "$timestamp_path"
    find "$srcdir_path" -newer "$timestamp_path" -execdir touch --date="$tag_commit_date" '{}' '+'

    trap - ERR HUP INT QUIT TERM
fi
[ -f "$timestamp_path" ]
