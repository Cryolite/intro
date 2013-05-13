#!/usr/bin/env bash

set -e

src=`wget --quiet --output-document=- 'http://www.boost.org/users/history/'`
src=`echo "$src" | grep -Eo '>Version [[:digit:]]+(\.[[:digit:]]+){0,2}<'`
src=`echo "$src" | grep -Eo "[[:digit:]]+(\\.[[:digit:]]+){0,2}"`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n | tail --lines=1 | tr --delete '\n'
