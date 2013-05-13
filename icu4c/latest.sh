#!/usr/bin/env bash

set -e

src=`wget --quiet --output-document=- 'http://site.icu-project.org/download'`
src=`echo "$src" | grep -E 'ICU4C'`
src=`echo "$src" | grep -Eo '>[[:digit:]]+(\.[[:digit:]]+){0,3}<'`
src=`echo "$src" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,3}'`
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail --lines=1 | tr --delete '\n'
