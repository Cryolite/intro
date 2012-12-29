#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "$0: error:" 1>&2
  exit 1
fi

if [ ! -x "$1" ]; then
  echo "$0: error: $1: command not found" 1>&2
  exit 1
fi

if which head 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: head: command not found" 1>&2
  exit 1
fi

if which grep 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: grep: command not found" 1>&2
  exit 1
fi

if echo -n "$1" | grep -Fq '/g++-wrapper'; then
  tmp=`LANG=C "$1" --version | head --lines=1`
  if echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+ [[:digit:]]{8} \\(((experimental)|(prerelease))\\)"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
    ver=`echo -n "$ver" | grep -Eo "^[[:digit:]]+\\.[[:digit:]]+"`
    date=`echo -n "$tmp" | grep -Eo "[[:digit:]]{8}"`
    echo -n gcc-${ver}_${date}
    exit 0
  elif echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
    echo -n gcc-$ver
    exit 0
  else
    echo "$0: error: cannot extract GCC version" 1>&2
    exit 1
  fi
elif echo -n "$1" | grep -Fq '/clang++-wrapper'; then
  if which dirname 1>/dev/null 2>&1; then
    :
  else
    echo "$0: error: dirname: command not found" 1>&2
    exit 1
  fi
  dir=`dirname "$1"`
  [ -x "${dir}/g++-wrapper" ] || exit 1
  tmp=`LANG=C "${dir}/g++-wrapper" --version | head --lines=1`
  if echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+ [[:digit:]]{8} \\(((experimental)|(prerelease))\\)"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
    ver=`echo -n "$ver" | grep -Eo "^[[:digit:]]+\\.[[:digit:]]+"`
    date=`echo -n "$tmp" | grep -Eo "[[:digit:]]{8}"`
    result=gcc-${ver}_${date}
  elif echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
    result=gcc-${ver}
  else
    echo "$0: error: cannot extract GCC version" 1>&2
    exit 1
  fi
  tmp=`LANG=C "$1" --version | head --lines=1`
  if echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+ \\(trunk [[:digit:]]+\\)"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+"`
    rev=`echo -n "$tmp" | grep -Eo "trunk [[:digit:]]+"`
    rev=`echo -n "$rev" | grep -Eo "[[:digit:]]+"`
    echo -n "${result}_${ver}_${rev}"
    exit 0
  elif echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+"`
    echo -n "${result}_${ver}"
    exit 0
  else
    echo "$0: error: cannot extract Clang version" 1>&2
    exit 1
  fi
elif echo -n "$1" | grep -Fq '/icpc-wrapper'; then
  if which dirname 1>/dev/null 2>&1; then
    :
  else
    echo "$0: error: dirname: command not found" 1>&2
    exit 1
  fi
  dir=`dirname "$1"`
  [ -x "${dir}/g++-wrapper" ] || exit 1
  tmp=`LANG=C "${dir}/g++-wrapper" --version | head --lines=1`
  if echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+ [[:digit:]]{8} \\(((experimental)|(prerelease))\\)"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
    ver=`echo -n "$ver" | grep -Eo "^[[:digit:]]+\\.[[:digit:]]+"`
    date=`echo -n "$tmp" | grep -Eo "[[:digit:]]{8}"`
    gcc_ver="${ver}_${date}"
  elif echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
    gcc_ver="${ver}"
  else
    echo "$0: error: cannot extract GCC version" 1>&2
    exit 1
  fi
  tmp=`LANG=C "$1" --version | head --lines=1`
  if echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"; then
    ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
    echo -n "intel-${ver}_${gcc_ver}"
    exit 0
  else
    echo "$0: error: cannot extract ICC version" 1>&2
    exit 1
  fi
else
  echo "$0: $1: error: unknown command" 1>&2
  exit 1
fi
