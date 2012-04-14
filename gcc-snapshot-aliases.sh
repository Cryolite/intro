#!/usr/bin/env sh

#url_prefix='http://gcc.igor.onlinedirect.bg'            # Bulgaria
#url_prefix='http://gcc.parentingamerica.com'            # Canada
#url_prefix='http://gcc.skazkaforyou.com'                # Canada
#url_prefix='http://fileboar.com/gcc'                    # US
#url_prefix='http://gcc.petsads.us'                      # US +
#url_prefix='http://mirrors-us.seosue.com/gcc'           # US
url_prefix='http://ftp.dti.ad.jp/pub/lang/gcc'          # Japan ++
#url_prefix='http://ftp.tsukuba.wide.ad.jp/software/gcc' # Japan +++

snapshots_src=`curl --silent "${url_prefix}/snapshots/" || exit 1`

versions=`{ /bin/echo -n "$snapshots_src" || exit 1; }                               \
    | { grep -Eo "[[:digit:]]+\\.[[:digit:]]+(\\.0-RC)?-[[:digit:]]{8}" || exit 1; } \
    | { sort -u || exit 1; }`

majors=`{ /bin/echo -n "$versions" || exit 1; }              \
    | { grep -Eo "^[[:digit:]]+\\.[[:digit:]]+" || exit 1; } \
    | { sort -u -t . -k 1,1n -k 2,2n || exit 1; }`

aliases=
for major in $majors; do
    ver=`{ /bin/echo -n "$versions" || exit 1; } \
	| { grep -Eo "${major}-[[:digit:]]{8}" || exit 1; } \
	| { tail --lines=1 || exit 1; }`
    aliases=$aliases${aliases:+ }${major}-latest,$ver
done

latest_major=`{ /bin/echo -n "$majors" || exit 1; } | { tail --lines=1 || exit 1; }`
snapshot=`{ /bin/echo -n "$versions" || exit 1; } \
    | { grep -Eo "${latest_major}-[[:digit:]]{8}" || exit 1; } \
    | { sort -u -t - -k 2,2n || exit 1; } \
    | { tail --lines=1 || exit 1; }`

/bin/echo -n "$aliases${aliases:+ }snapshot,$snapshot"
