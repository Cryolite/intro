#!/usr/bin/env sh

#url_prefix='http://gcc.igor.onlinedirect.bg'            # Bulgaria
#url_prefix='http://gcc.parentingamerica.com'            # Canada
#url_prefix='http://gcc.skazkaforyou.com'                # Canada
#url_prefix='http://fileboar.com/gcc'                    # US
#url_prefix='http://gcc.petsads.us'                      # US +
#url_prefix='http://mirrors-us.seosue.com/gcc'           # US
url_prefix='http://ftp.tsukuba.wide.ad.jp/software/gcc' # Japan +++

builtin=`{ (LANG=C g++ -dumpversion) || exit 1; }`

releases_src=`curl --silent "${url_prefix}/releases/" || exit 1`
snapshots_src=`curl --silent "${url_prefix}/snapshots/" || exit 1`

majors=`{ /bin/echo -n $snapshots_src || exit 1; }                                    \
    | { grep -oE "LATEST-[[:digit:]]+\\.[[:digit:]]+" || exit 1; }                    \
    | { sed -e 's/^LATEST-\([[:digit:]]\{1,\}\.[[:digit:]]\{1,\}\)$/\1/' || exit 1; } \
    | { sort -u -t . -k 1,1n -k 2,2n || exit 1; }                                     \
    | { tail --lines=4 || exit 1; }`

versions=
for major in $majors; do
    version=`{ /bin/echo -n $releases_src || exit 1; }                                            \
	| { grep -oE "gcc-${major}\\.[[:digit:]]+/" || exit 1; }                                  \
	| { sed -e 's/^gcc-\([[:digit:]]\{1,\}\(\.[[:digit:]]\{1,\}\)\{2\}\)\/$/\1/' || exit 1; } \
	| { sort -u -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }                                     \
	| { tail --lines=1 || exit 1; }`
    if [ -z "$version" ]; then
	version=`{ /bin/echo -n $snapshots_src || exit 1; }               \
	    | { grep -oE "${major}(\\.0-RC)?-[[:digit:]]{8}" || exit 1; } \
	    | { sort -u || exit 1; }                                      \
	    | { tail --lines=1 || exit 1; }`
    fi
    if [ -z "$version" ]; then
	exit 1;
    fi
    versions=${version}${versions:+ ${versions}}
done
versions=`{ /bin/echo $versions || exit 1; } \
    | { tr ' ' '\n' || exit 1; }             \
    | { sort -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }`

/bin/echo -n $builtin $versions
exit 0
