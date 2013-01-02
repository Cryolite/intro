#!/usr/bin/env sh

uri_prefix='http://ftp.jaist.ac.jp/pub/GNU/mpfr/'
#uri_prefix='http://ftp.tsukuba.wide.ad.jp/software/mpfr/' # Tsukuba Univ, Tsukuba, Ibaraki, Japan
#uri_prefix='http://ftp.nara.wide.ad.jp/pub/GNU/gnu/mpfr/' # NAIST, Ikoma, Nara, Japan
#uri_prefix='http://www.ring.gr.jp/archives/GNU/mpfr/'
#uri_prefix='ftp://ftp.gnu.org/gnu/mpfr/'

src=`wget --quiet --output-document=- "$uri_prefix"` || exit 1
src=`echo "$src" | grep -Eo 'mpfr-[[:digit:]]+(\.[[:digit:]]+){0,2}\.tar\.((gz)|(bz2))'` || exit 1
src=`echo "$src" | grep -Eo '^mpfr-[[:digit:]]+(\.[[:digit:]]+){0,2}'` || exit 1
src=`echo "$src" | grep -Eo '[[:digit:]]+(\\.[[:digit:]]+){0,2}$'` || exit 1
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
