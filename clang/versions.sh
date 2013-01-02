#!/usr/bin/env sh

versions=`wget --quiet --output-document=- 'http://llvm.org/releases/download.html'` || exit 1
versions=`echo -n "$versions" | grep -oE "Download LLVM [[:digit:]]+\\.[[:digit:]]+"` || exit 1
versions=`echo -n "$versions" | grep -oE "[[:digit:]]+\\.[[:digit:]]+"` || exit 1
versions=`echo -n "$versions" | sort -u -t . -k 1,1n -k 2,2n` || exit 1
echo -n $versions
