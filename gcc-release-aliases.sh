#!/usr/bin/env sh

#url_prefix='http://gcc.igor.onlinedirect.bg'            # Bulgaria
#url_prefix='http://gcc.parentingamerica.com'            # Canada
#url_prefix='http://gcc.skazkaforyou.com'                # Canada
#url_prefix='http://fileboar.com/gcc'                    # US
#url_prefix='http://gcc.petsads.us'                      # US +
#url_prefix='http://mirrors-us.seosue.com/gcc'           # US
url_prefix='http://ftp.dti.ad.jp/pub/lang/gcc'          # Japan ++
#url_prefix='http://ftp.tsukuba.wide.ad.jp/software/gcc' # Japan +++

releases_src=`curl --silent "${url_prefix}/releases/" || exit 1`

versions=`{ /bin/echo -n "$releases_src" || exit 1; }                          \
    | { grep -Eo "gcc-[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+" || exit 1; } \
    | { grep -Eo "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+" || exit 1; }     \
    | { sort -u -t . -k 1,1n -k 2,2n -k 3,3n || exit 1; }`

majors=`{ /bin/echo -n "$versions" || exit 1; }              \
    | { grep -Eo "^[[:digit:]]+\\.[[:digit:]]+" || exit 1; } \
    | { sort -u -t . -k 1,1n -k 2,2n || exit 1; }`

current_major=`{ /bin/echo -n "$majors" || exit 1; } \
    | { tail --lines=1 || exit 1; }`
current=`{ /bin/echo -n "$versions" || exit 1; }                 \
    | { grep -Eo "^${current_major}\\.[[:digit:]]+" || exit 1; } \
    | { tail --lines=1 || exit 1; }`
previous_major=`{ /bin/echo -n "$majors" || exit 1; } \
    | { tail --lines=2 || exit 1; }                   \
    | { head --lines=1 || exit 1; }`
previous=`{ /bin/echo -n "$versions" || exit 1; }                 \
    | { grep -Eo "^${previous_major}\\.[[:digit:]]+" || exit 1; } \
    | { tail --lines=1 || exit 1; }`
oldest_major=`{ /bin/echo -n "$majors" || exit 1; } \
    | { tail --lines=3 || exit 1; }                 \
    | { head --lines=1 || exit 1; }`
oldest=`{ /bin/echo -n "$versions" || exit 1; }                 \
    | { grep -Eo "^${oldest_major}\\.[[:digit:]]+" || exit 1; } \
    | { tail --lines=1 || exit 1; }`
/bin/echo -n current,$current previous,$previous oldest,$oldest
