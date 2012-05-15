#!/bin/sh

uri_prefix='http://ftp.jaist.ac.jp/pub/GNU/binutils/'
#uri_prefix='http://ftp.nara.wide.ad.jp/pub/GNU/gnu/binutils/'
#uri_prefix='http://ftp.tsukuba.wide.ad.jp/software/binutils/'
#uri_prefix='http://www.ring.gr.jp/archives/GNU/binutils/'

src=`curl --silent "$uri_prefix" || exit 1`
src=`echo "$src" | { grep -Eo 'binutils-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))' || exit 1; }`
src=`echo "$src" | { grep -Eo 'binutils-[[:digit:]]+(\.[[:digit:]]+){0,2}' || exit 1; }`
src=`echo "$src" | { grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,2}' || exit 1; }`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
