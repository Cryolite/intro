#!/usr/bin/env sh

src=`wget --quiet --output-document=- 'http://site.icu-project.org/download'` || exit 1
src=`echo "$src" | grep -E 'ICU4C'` || exit 1
src=`echo "$src" | grep -Eo '>[[:digit:]]+(\.[[:digit:]]+){0,3}<'` || exit 1
src=`echo "$src" | grep -Eo '[[:digit:]]+(\.[[:digit:]]+){0,3}'` || exit 1
echo "$src" | sort -u -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail --lines=1 | tr --delete '\n'
