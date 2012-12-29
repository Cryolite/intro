#!/usr/bin/env sh

. "bin/vars32.sh"

if [ $? -eq 0 -a -e "`pwd`/bin/vars32debug.sh" ]; then
    if [ -d "`pwd`/lib/debug" ]; then
        for i in `find "\`pwd\`/lib/debug" -maxdepth 1 -type f \( -name 'lib*.a' -o -name 'lib*.so.*' -executable \)`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LIBRARY_PATH="`pwd`/lib/debug${LIBRARY_PATH:+:$LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/lib32/debug" ]; then
        for i in `find "\`pwd\`/lib32/debug" -maxdepth 1 -type f \( -name 'lib*.a' -o -name 'lib*.so.*' -executable \)`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LIBRARY_PATH="`pwd`/lib32/debug${LIBRARY_PATH:+:$LIBRARY_PATH}"
                break
            fi
        done
    fi
    export LIBRARY_PATH

    if [ -d "`pwd`/lib/debug" ]; then
        for i in `find "\`pwd\`/lib/debug" -maxdepth 1 -type f -name 'lib*.so.*' -executable`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LD_LIBRARY_PATH="`pwd`/lib/debug${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/lib32/debug" ]; then
        for i in `find "\`pwd\`/lib32/debug" -maxdepth 1 -type f -name 'lib*.so.*' -executable`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LD_LIBRARY_PATH="`pwd`/lib32/debug${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                break
            fi
        done
    fi
    export LD_LIBRARY_PATH
    true
else
    echo "vars32debug.sh: should be invoked after \`cd PREFIX'" 1>&2
    false
fi
