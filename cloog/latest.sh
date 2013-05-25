#!/usr/bin/env sh

set -e

uri_prefix='http://www.bastoul.net/cloog/pages/download/'

src=`wget --quiet --output-document=- "$uri_prefix"`
src=`echo "$src" | grep -Eo 'cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'`
src=`echo "$src" | grep -Eo '^cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
src=`echo "$src" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}$'`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
