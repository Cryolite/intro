#!/usr/bin/env sh

#url_prefix='http://gcc.igor.onlinedirect.bg'            # Bulgaria
#url_prefix='http://gcc.parentingamerica.com'            # Canada
#url_prefix='http://gcc.skazkaforyou.com'                # Canada
#url_prefix='http://fileboar.com/gcc'                    # US
#url_prefix='http://gcc.petsads.us'                      # US +
#url_prefix='http://mirrors-us.seosue.com/gcc'           # US
url_prefix='http://ftp.tsukuba.wide.ad.jp/software/gcc' # Japan +++

builtin=`{ (LANG=C g++ -dumpversion) || exit 1; } \
    | { tr --delete '\n' || exit 1; }`

releases_src=`curl --silent "${url_prefix}/releases/" || exit 1`
snapshots_src=`curl --silent "${url_prefix}/snapshots/" || exit 1`

majors=`{ /bin/echo -n $snapshots_src || exit 1; } \
    | { grep -oE "LATEST-[[:digit:]]+\\.[[:digit:]]+" || exit 1; } \
    | { sed -e 's/^LATEST-\([[:digit:]]\{1,\}\.[[:digit:]]\{1,\}\)$/\1/' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; } \
    | { uniq || exit 1; } \
    | { head --lines=4 || exit 1; }`

versions=
for major in $majors; do
    version=`{ /bin/echo -n $releases_src || exit 1; } \
	| { grep -oE "gcc-${major}\\.[[:digit:]]+/" || exit 1; } \
	| { sed -e 's/^gcc-\([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{2\}\)\/$/\1/' || exit 1; } \
	| { sort --version-sort --reverse || exit 1; } \
	| { uniq || exit 1; } \
	| { head --lines=1 || exit 1; }`
    if [ -z "$version" ]; then
	version=`{ /bin/echo -n $snapshots_src || exit 1; } \
	    | { grep -oE "${major}(\\.0-RC)?-[[:digit:]]{8}" || exit 1; } \
	    | { sort --version-sort --reverse || exit 1; } \
	    | { uniq || exit 1; } \
	    | { head --lines=1 || exit 1; }`
    fi
    if [ -z "$version" ]; then
	exit 1;
    fi
    versions=${version}${versions:+ ${versions}}
done
versions=`{ /bin/echo $versions || exit 1; } \
    | { tr ' ' '\n' || exit 1; } \
    | { sort --version-sort --reverse || exit 1; }`

/bin/echo -n $builtin $versions
exit 0
