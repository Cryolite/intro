#!/usr/bin/env bash

set -e

uri='http://valgrind.org/downloads/current.html'

src=`wget --quiet --output-document=- "$uri"`
src=`echo "$src" | grep -Eo 'valgrind-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.bz2'`
src=`echo "$src" | grep -Eo '^valgrind-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
src=`echo "$src" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}$'`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
