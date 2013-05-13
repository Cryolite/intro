#!/usr/bin/env bash

set -e

uri_prefix='http://bugseng.com/products/ppl/download/ftp/releases/'

src=`wget --quiet --output-document=- "$uri_prefix"`
src=`echo "$src" | grep -oE '[[:digit:]]+(\.[[:digit:]]+){0,2}/'`
src=`echo "$src" | grep -oE '[[:digit:]]+(\.[[:digit:]]+){0,2}'`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
