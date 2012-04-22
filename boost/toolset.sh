#!/usr/bin/env bash

[ -x "$1" ] || exit 1

if echo -n "$1" | grep -Fq '/g++-wrapper'; then
    tmp=`env LANG=C "$1" --version | head --lines=1`
    if echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+ [[:digit:]]{8} \\(((experimental)|(prerelease))\\)"; then
	ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
	date=`echo -n "$tmp" | grep -Eo "[[:digit:]]{8}"`
	echo -n gcc-${ver}_${date}
	exit 0
    elif echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"; then
	ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
	echo -n gcc-$ver
	exit 0
    else
	exit 1
    fi
elif echo -n "$1" | grep -Fq '/clang++-wrapper'; then
    dir=`dirname "$1"`
    [ -x "${dir}/g++-wrapper" ] || exit 1
    tmp=`env LANG=C "${dir}/g++-wrapper" --version | head --lines=1`
    if echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+ [[:digit:]]{8} \\(((experimental)|(prerelease))\\)"; then
	ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
	date=`echo -n "$tmp" | grep -Eo "[[:digit:]]{8}"`
	result=gcc-${ver}_${date}
    elif echo -n "$tmp" | grep -Eq "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"; then
	ver=`echo -n "$tmp" | grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"`
	result=gcc-${ver}
    else
	exit 1
    fi
    tmp=`env LANG=C "$1" --version | head --lines=1`
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
	exit 1
    fi
else
    exit 1
fi
