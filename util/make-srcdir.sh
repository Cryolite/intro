#!/usr/bin/env bash

PS4='+util/make-srcdir.sh:$LINENO: '
set -ex

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq c2f75877-d9e0-4b69-84e1-fc6c19fc679d "$intro_root/util/make-srcdir.sh"

# Test if `optget' is an enhanced version or an old version.
if getopt --test 2>&1 | grep -Fq -- '--'; then
  echo "util/make-srcdir.sh: requires an enhanced version of \`getopt'" >&2
  exit 1
fi
getopt --test || status=$?
if [ $status -ne 4 ]; then
  echo "util/make-srcdir.sh: requires an enhanced version of \`getopt'" >&2
  exit 1
fi

args=`getopt                   \
        -n util/make-srcdir.sh \
        -l url:                \
        -l tarball:            \
        -l bzip2               \
        -l gzip                \
        -l srcdir:             \
        -l timestamp:          \
        -o h                   \
        -- "$@"`
eval "args=($args)"

declare -a urls
tarball_path=
tar_filter_option=
srcdir_path=
timestamp_basename=
for arg in "${args[@]}"; do
  if [ -z "$prev_arg" ]; then
    case "$arg" in
    --url)
      prev_arg=--url
      ;;
    --tarball)
      if [ -n "$tarball_path" ]; then
        echo "util/make-srcdir.sh: error: duplicate \`--tarball' option" >&2
        exit 1
      fi
      prev_arg=--tarball
      ;;
    --bzip2)
      if [ -n "$tar_filter_option" ]; then
        echo "util/make-srcdir.sh: error: duplicate \`--bzip2' or \`--gzip' options" >&2
        exit 1
      fi
      tar_filter_option=-j
      ;;
    --gzip)
      if [ -n "$tar_filter_option" ]; then
        echo "util/make-srcdir.sh: error: duplicate \`--bzip2' or \`--gzip' options" >&2
        exit 1
      fi
      tar_filter_option=-z
      ;;
    --srcdir)
      if [ -n "$srcdir_path" ]; then
        echo "util/make-srcdir.sh: error: duplicate \`--srcdir' options" >&2
        exit 1
      fi
      prev_arg=--srcdir
      ;;
    --timestamp)
      if [ -n "$timestamp_basename" ]; then
        echo "util/make-srcdir.sh: error: duplicate \`--timestamp' options" >&2
        exit 1
      fi
      prev_arg=--timestamp
      ;;
    -h)
      echo "util/make-srcdir.sh: error: help is not available"
      exit 1
      ;;
    --)
      ;;
    *)
      echo "util/make-srcdir.sh: error: an invalid argument \`$arg'" >&2
      exit 1
      ;;
    esac
  else
    # `$prev_arg' is not empty.
    case "$prev_arg" in
    --url)
      if [ -z "$arg" ]; then
        echo "util/make-srcdir.sh: error: the empty string for the argument of \`--url' option" >&2
        exit 1
      fi
      urls+=("$arg")
      ;;
    --tarball)
      if [ -z "$arg" ]; then
        echo "util/make-srcdir.sh: error: the empty string for the argument of \`--tarball' option" >&2
        exit 1
      fi
      tarball_path="$arg"
      ;;
    --srcdir)
      if [ -z "$arg" ]; then
        echo "util/make-srcdir.sh: error: the empty string for the argument of \`--srcdir' option" >&2
        exit 1
      fi
      srcdir_path="$arg"
      ;;
    --timestamp)
      if [ -z "$arg" ]; then
        echo "util/make-srcdir.sh: error: the empty string for the argument of \`--timestamp' option" >&2
        exit 1
      fi
      timestamp_basename="$arg"
      ;;
    *)
      echo "util/make-srcdir.sh: error: a logic error" >&2
      exit 1
      ;;
    esac
    prev_arg=
  fi
done

if [ ${#urls[@]} -eq 0 ]; then
  echo "util/make-srcdir.sh: error: no \`--url' option" >&2
  exit 1
fi

if [ -z "$tarball_path" ]; then
  echo "util/make-srcdir.sh: error: no \`--tarball' option" >&2
  exit 1
fi
tarball_path="`readlink -f "$tarball_path"`"
tarball_basename="`basename "$tarball_path"`"

if [ -z "$tar_filter_option" ]; then
  echo "util/make-srcdir.sh: error: no \`--bzip2' or \`--gzip' option" >&2
  exit 1
fi

if [ -z "$srcdir_path" ]; then
  echo "util/make-srcdir.sh: error: no \`--srcdir' option" >&2
  exit 1
fi
srcdir_path="`readlink -f "$srcdir_path"`"
srcdir_basename="`basename "$srcdir_path"`"

if [ -z "$timestamp_basename" ]; then
  echo "util/make-srcdir.sh: error: no \`--timestamp' option" >&2
  exit 1
fi
if echo "$timestamp_basename" | grep -Fq '/'; then
  echo "util/make-srcdir.sh: error: the argument of \`--timestamp' contains a slash \`/'" >&2
  exit 1
fi

tmpdir_path=`mktemp -d --tmpdir=.`
tmpdir_path="`readlink -f "$tmpdir_path"`"

cleanup ()
{
  rm -r "$tmpdir_path"
}
trap cleanup ERR HUP INT QUIT TERM

tarball_basename_tmp=
for url in "${urls[@]}"; do
  tarball_basename_tmp_tmp="`basename "$url"`"
  if [ -n "$tarball_basename_tmp" ]; then
    if [ "$tarball_basename_tmp_tmp" != "$tarball_basename_tmp" ]; then
      echo "util/make-srcdir.sh: error: different base names between \`$url_orig' and \`$url'" >&2
      exit 1
    fi
  else
    if [ -z "$tarball_basename_tmp_tmp" ]; then
      echo "util/make-srcdir.sh: error: a base name extracted from the URL \`$url' is the empty string" >&2
      exit 1
    fi
    url_orig="$url"
    tarball_basename_tmp="$tarball_basename_tmp_tmp"
  fi
done
[ -n "$tarball_basename_tmp" ]

if [ '!' -f "$tarball_path" ]; then
  for url in "${urls[@]}"; do
    ( cd "$tmpdir_path" && wget -q -t 3 --no-clobber -- "$url" ) && break
  done
  if [ "$tarball_basename_tmp" != "$tarball_basename" ]; then
    [ -f "$tmpdir_path/$tarball_basename_tmp" ]
    ( cd "$tmpdir_path" && mv -nT "$tarball_basename_tmp" "$tarball_basename" )
    [ '!' -e "$tmpdir_path/$tarball_basename_tmp" ]
  fi
  [ -f "$tmpdir_path/$tarball_basename" ]
  tarball_path_tmp="$tmpdir_path/$tarball_basename"
else
  tarball_path_tmp="$tarball_path"
fi
tarball_path_tmp="`readlink -f "$tarball_path_tmp"`"
[ -f "$tarball_path_tmp" ]

expand ()
{
  list_file_path="`mktemp --tmpdir="$tmpdir_path"`"
  tar -x $tar_filter_option -v -f "$tarball_path_tmp" -C "$tmpdir_path" >"$list_file_path"
  srcdir_basename_tmp="`grep -Eo '^[^/]*' "$list_file_path" | uniq`"
  if [ "`echo "$srcdir_basename_tmp" | wc -l`" -ne 1 ]; then
    echo "util/make-srcdir.sh: error: could not extract the base name of the source directory from the tarball" >&2
    exit 1
  fi
  if [ "$srcdir_basename_tmp" != "$srcdir_basename" ]; then
    [ -d "$tmpdir_path/$srcdir_basename_tmp" ]
    ( cd "$tmpdir_path" && mv -nT "$srcdir_basename_tmp" "$srcdir_basename" )
    [ '!' -e "$tmpdir_path/$srcdir_basename_tmp" ]
  fi
  [ -d "$tmpdir_path/$srcdir_basename" ]
  srcdir_path_tmp="$tmpdir_path/$srcdir_basename"
}

if [ -f "$srcdir_path/$timestamp_basename" ]; then
  if [ "$tarball_path_tmp" -nt "$srcdir_path/$timestamp_basename" ]; then
    # `srcdir_path_tmp` is set.
    expand
  else
    srcdir_path_tmp="$srcdir_path"
  fi
else
  # `srcdir_path_tmp` is set.
  expand
fi
srcdir_path_tmp="`readlink -f "$srcdir_path_tmp"`"
[ -d "$srcdir_path_tmp" ]

if [ -f "$srcdir_path_tmp/$timestamp_basename" ]; then
  [ "$srcdir_path_tmp" = "$srcdir_path" ]
else
  [ "$srcdir_path_tmp" = "$tmpdir_path/$srcdir_basename" ]
  timestamp_path_tmp="$srcdir_path_tmp/$timestamp_basename"
  touch "$timestamp_path_tmp"
  find "$srcdir_path_tmp" -newer "$tarball_path_tmp" -execdir touch --reference="$tarball_path_tmp" '{}' '+'
  find "$srcdir_path_tmp" -print0 | xargs -0 -L 1 bash -c '[ "$1" -ot "$0" ] && touch --reference="$1" "$0" || true' "$timestamp_path_tmp"
  find "$srcdir_path_tmp" -print0 | xargs -0 -L 1 bash -c '[ "$1" -nt "$0" ] && touch --reference="$1" "$0" || true' "$timestamp_path_tmp"
fi
[ -f "$srcdir_path_tmp/$timestamp_basename" ]

if [ "$tarball_path_tmp" != "$tarball_path" ]; then
  [ "$tarball_path_tmp" = "$tmpdir_path/$tarball_basename" ]
  [ -f "$tarball_path_tmp" ]
  mv -nT "$tarball_path_tmp" "$tarball_path"
  [ '!' -e "$tarball_path_tmp" ]
fi
[ -f "$tarball_path" ]

if [ "$srcdir_path_tmp" != "$srcdir_path" ]; then
  [ "$srcdir_path_tmp" = "$tmpdir_path/$srcdir_basename" ]
  if [ -e "$srcdir_path" ]; then
    rm -r "$srcdir_path"
  fi
  [ -d "$srcdir_path_tmp" ]
  mv -nT "$srcdir_path_tmp" "$srcdir_path"
  [ '!' -e "$srcdir_path_tmp" ]
fi
[ -d "$srcdir_path" ]

rm -r "$tmpdir_path"
