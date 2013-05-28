#!/usr/bin/env bash

set -e

versions=`wget --quiet --output-document=- 'http://llvm.org/releases/download.html'`
versions=`echo -n "$versions" | grep -oE "Download LLVM [[:digit:]]+\\.[[:digit:]]+"`
versions=`echo -n "$versions" | grep -oE "[[:digit:]]+\\.[[:digit:]]+"`
versions=`echo -n "$versions" | sort -u -t . -k 1,1n -k 2,2n`
echo -n $versions
