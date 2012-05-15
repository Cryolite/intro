#!/bin/sh

uri_prefix='http://ftp.dti.ad.jp/pub/lang/gcc/infrastructure/'
#uri_prefix='http://ftp.tsukuba.wide.ad.jp/software/gcc/infrastructure/'

src=`curl --silent "$uri_prefix" || exit 1`
src=`echo "$src" | { grep -Eo 'cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))' || exit 1; }`
src=`echo "$src" | { grep -Eo '^cloog-[[:digit:]]+(\.[[:digit:]]+){0,2}' || exit 1; }`
src=`echo "$src" | { grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}$' || exit 1; }`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
