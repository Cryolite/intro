#!/usr/bin/env bash

set -e

src=`wget --quiet --output-document=- 'http://www.multiprecision.org/index.php?prog=mpc&page=download'`
src=`echo "$src" | grep -Eo 'mpc-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'`
src=`echo "$src" | grep -Eo 'mpc-[[:digit:]]+(\.[[:digit:]]+){0,2}'`
src=`echo "$src" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
