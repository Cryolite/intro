#!/usr/bin/env bash

PS4='+util/git-checkout.sh:$LINENO: '
set -ex

intro_root="$(cd "$(dirname "$0")"; cd ..; pwd)"
grep -Fq 670eecb8-ebd1-4b90-8816-1fd96235c36a "$intro_root/util/git-checkout.sh"

# Test if `optget' is an enhanced version or an old version.
if getopt --test 2>&1 | grep -Fq -- '--'; then
    echo "util/git-checkout.sh: error: requires an enhanced version of \`getopt'" >&2
    exit 1
fi
getopt --test || status=$?
if [ $status -ne 4 ]; then
    echo "util/git-checkout.sh: error: requires an enhanced version of \`getopt'" >&2
    exit 1
fi

args=$(getopt                    \
         -n util/git-checkout.sh \
         -l url:                 \
         -l srcdir:              \
         -l timestamp:           \
         -o h                    \
         -- "$@")
eval "args=($args)"

url=
srcdir_path=
timestamp_basename=
for arg in "${args[@]}"; do
    if [ -z "$prev_arg" ]; then
        case "$arg" in
        --url)
            if [ -n "$url" ]; then
                echo "util/git-checkout.sh: error: duplicate \`--url' options" >&2
                exit 1
            fi
            prev_arg=--url
            ;;
        --srcdir)
            if [ -n "$srcdir_path" ]; then
                echo "util/git-checkout.sh: error: duplicate \`--srcdir' options" >&2
                exit 1
            fi
            prev_arg=--srcdir
            ;;
        --timestamp)
            if [ -n "$timestamp_basename" ]; then
                echo "util/git-checkout.sh: error: duplicate \`--timestamp' options" >&2
                exit 1
            fi
            prev_arg=--timestamp
            ;;
        -h)
            echo "util/git-checkout.sh: error: help is not available" >&2
            exit 1
            ;;
        --)
            ;;
        *)
            echo "util/git-checkout.sh: error: an invalid argument \`$arg'" >&2
            exit 1
            ;;
        esac
    else
        case "$prev_arg" in
        --url)
            if [ -z "$arg" ]; then
                echo "util/git-checkout.sh: error: the empty string for the argument of \`--url' option" >&2
                exit 1
            fi
            url="$arg"
            ;;
        --srcdir)
            if [ -z "$arg" ]; then
                echo "util/git-checkout.sh: error: the empty string for the argument of \`--srcdir' option" >&2
                exit 1
            fi
            srcdir_path="$arg"
            ;;
        --timestamp)
            if [ -z "$arg" ]; then
                echo "util/git-checkout.sh: error: the empty string for the argument of \`--timestamp' option" >&2
                exit 1
            fi
            timestamp_basename="$arg"
            ;;
        *)
            echo "util/git-checkout.sh: error: a logic error" >&2
            exit 1
            ;;
        esac
        prev_arg=
    fi
done

if [ -z "$url" ]; then
    echo "util/git-checkout.sh: error: no \`--url' option" >&2
    exit 1
fi

if [ -z "$srcdir_path" ]; then
    echo "util/git-checkout.sh: error: no \`--srcdir' option" >&2
    exit 1
fi
srcdir_path="$(readlink -f "$srcdir_path")"
srcdir_basename="$(basename "$srcdir_path")"

if [ -z "$timestamp_basename" ]; then
    echo "util/git-checkout.sh: error: no \`--timestamp' option" >&2
    exit 1
fi
if echo "$timestamp_basename" | grep -Fq '/'; then
    echo "util/git-checkout.sh: error: the argument of \`--timestamp' contains a slash \`/'" >&2
    exit 1
fi
timestamp_path="$srcdir_path/$timestamp_basename"

if [ -e "$srcdir_path" ]; then
    if [ -f "$timestamp_path" ]; then
        ( cd "$srcdir_path" && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] )
        ( cd "$srcdir_path" && git clean -ffdx )
    else
        echo "util/git-checkout.sh: error: \`$srcdir' already exists but does not have the timestamp \`$timestamp_path'" >&2
        exit 1
    fi
fi

cleanup ()
{
    if [ -e "$srcdir_path" ]; then
        [ -d "$srcdir_path" ] || {
            echo 'util/git-checkout.sh: warning: a logic error in rollback process, forced to proceed' >&2;
        }
        rm -r "$srcdir_path"
    fi
}
trap cleanup ERR HUP INT QUIT TERM

if [ '!' -e "$srcdir_path" ]; then
    ( cd "$(dirname "$srcdir_path")" && git clone "$url" "$srcdir_basename" )
fi
( cd "$srcdir_path" && [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ] )

( cd "$srcdir_path" && git pull --ff-only )

last_commit_date="$(cd "$srcdir_path" && LANG=C git log -1 --date=iso)"
last_commit_date="$(echo "$last_commit_date" | grep -E '^Date:')"
if [ "$(echo "$last_commit_date" | wc -l)" -ne 1 ]; then
    echo "util/git-checkout.sh: error: failed to extract the date of the last commit" >&2
    exit 1
fi
last_commit_date="$(echo "$last_commit_date" | sed -e 's/^Date:[[:space:]]*\(.*\)$/\1/')"
if echo "$last_commit_date" | grep -Eq '^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2} [+-][[:digit:]]{4}$'; then
    :
else
    echo "util/git-checkout.sh: error: failed to extract the date of the last commit" >&2
    exit 1
fi
find "$srcdir_path" -execdir touch --date="$last_commit_date" '{}' \+
touch --date="$last_commit_date" "$timestamp_path"
