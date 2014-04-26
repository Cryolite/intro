#!/usr/bin/env bash

intro_root=`(cd \`dirname "$0"\`; cd ..; pwd)`
grep -Fq 9ae5da01-d17c-4c4b-a9ec-2d77fd8e496c "$intro_root/cloog/download.sh"

PS4='+$0:$LINENO: '
set -ex

[ $# -eq 1 ]

version="$1"
echo "$version" | grep -Eq '^[[:digit:]]+(\.[[:digit:]]+(\.[[:digit:]]+)?)?$'

[ '!' -e "$intro_root/cloog-${version}.tar.gz.bak" ]
if [ -e "$intro_root/cloog-${version}.tar.gz" ]; then
  if [ -f "$intro_root/cloog-${version}.tar.gz" ]; then
    mv "$intro_root/cloog-${version}.tar.gz" "$intro_root/cloog-${version}.tar.gz.bak"
  else
    rm -r "$intro_root/cloog-${version}.tar.gz"
  fi
fi
[ '!' -e "$intro_root/cloog-${version}.tar.gz" ]

timestamp=528457b5-9e38-4c8f-ac97-fbdb3ccfdbe9

[ '!' -e "$intro_root/cloog-${version}.bak" ]
if [ -e "$intro_root/cloog-${version}" ]; then
  if [ -f "$intro_root/cloog-${version}/$timestamp" ]; then
    mv "$intro_root/cloog-${version}" "$intro_root/cloog-${version}.bak"
  else
    rm -r "$intro_root/cloog-${version}"
  fi
fi
[ '!' -e "$intro_root/cloog-${version}" ]

cleanup ()
{
  if [ -e "$intro_root/cloog-${version}.tar.gz" ]; then
    [ -f "$intro_root/cloog-${version}.tar.gz" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    rm -r "$intro_root/cloog-${version}.tar.gz"
  fi
  if [ -e "$intro_root/cloog-${version}" ]; then
    [ -d "$intro_root/cloog-${version}" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    rm -r "$intro_root/cloog-${version}"
  fi
  if [ -e "$intro_root/cloog-${version}.tar.gz.bak" ]; then
    [ -f "$intro_root/cloog-${version}.tar.gz.bak" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    mv "$intro_root/cloog-${version}.tar.gz.bak" "$intro_root/cloog-${version}.tar.gz"
  fi
  if [ -e "$intro_root/cloog-${version}.bak" ]; then
    [ -f "$intro_root/cloog-${version}.bak/$timestamp" ] || {
      echo 'warning: a logic error in rollback process, forced to proceed' >&2;
    }
    mv "$intro_root/cloog-${version}.bak" "$intro_root/cloog-${version}"
  fi
}
trap cleanup ERR HUP INT QUIT TERM

tarball=
if [ -e "$intro_root/cloog-${version}.tar.gz.bak" ]; then
  [ -f "$intro_root/cloog-${version}.tar.gz.bak" ]
  tarball="$intro_root/cloog-${version}.tar.gz.bak"
else
  urls=("http://www.bastoul.net/cloog/pages/download/cloog-${version}.tar.gz")
  for url in "${urls[@]}"; do
    ( cd "$intro_root" && wget --quiet -- "$url" ) && break
  done
  tarball="$intro_root/cloog-${version}.tar.gz"
fi
[ -f "$intro_root/cloog-${version}.tar.gz.bak" -o -f "$intro_root/cloog-${version}.tar.gz" ]
[ '!' '(' -f "$intro_root/cloog-${version}.tar.gz.bak" -a -f "$intro_root/cloog-${version}.tar.gz" ')' ]
[ -f "$tarball" ]

old_timestamp_path="$intro_root/cloog-${version}.bak/$timestamp"

srcdir=
if [ -e "$old_timestamp_path" ]; then
  [ -f "$old_timestamp_path" ]
  if [ "$tarball" -nt "$old_timestamp_path" ]; then
    tar -xzf "$tarball" --directory="$intro_root"
    srcdir="$intro_root/cloog-${version}"
  else
    srcdir="$intro_root/cloog-${version}.bak"
  fi
else
  tar -xzf "$tarball" --directory="$intro_root"
  srcdir="$intro_root/cloog-${version}"
fi
[ -d "$srcdir" ]

new_timestamp_path="$srcdir/$timestamp"

if [ -e "$new_timestamp_path" ]; then
  [ "$srcdir" = "$intro_root/cloog-${version}.bak" ]
  [ -f "$new_timestamp_path" ]
  [ '!' "$tarball" -nt "$new_timestamp_path" ]
else
  [ "$srcdir" = "$intro_root/cloog-${version}" ]
  touch "$new_timestamp_path"
  find "$srcdir" -newer "$tarball" -execdir touch --reference="$tarball" '{}' '+'
  find "$srcdir" -print0 | xargs -0 -L 1 bash -c '[ "$1" -ot "$0" ] && touch --reference="$1" "$0"; true' "$new_timestamp_path"
  find "$srcdir" -print0 | xargs -0 -L 1 bash -c '[ "$1" -nt "$0" ] && touch --reference="$1" "$0"; true' "$new_timestamp_path"
fi

if [ "$tarball" = "$intro_root/cloog-${version}.tar.gz.bak" ]; then
  [ '!' -e "$intro_root/cloog-${version}.tar.gz" ]
  mv "$intro_root/cloog-${version}.tar.gz.bak" "$intro_root/cloog-${version}.tar.gz"
fi

if [ "$srcdir" = "$intro_root/cloog-${version}.bak" ]; then
  [ '!' -e "$intro_root/cloog-${version}" ]
  mv "$intro_root/cloog-${version}.bak" "$intro_root/cloog-${version}"
fi

if [ -e "$intro_root/cloog-${version}.tar.gz.bak" ]; then
  [ -f "$intro_root/cloog-${version}.tar.gz.bak" ] || {
    echo 'warning: a logic error in commit process, forced to proceed' >&2;
  }
  rm -r "$intro_root/cloog-${version}.tar.gz.bak"
fi

if [ -e "$intro_root/cloog-${version}.bak" ]; then
  [ -f "$old_timestamp_path" ] || {
    echo 'warning: a logic error in commit process, forced to proceed' >&2;
  }
  rm -r "$intro_root/cloog-${version}.bak"
fi
