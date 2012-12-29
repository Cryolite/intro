#!/usr/bin/env sh

if [ -e "`pwd`/bin/vars32.sh" ]; then
    if [ -d "`pwd`/include" ]; then
        CPATH="`pwd`/include${CPATH:+:$CPATH}"
    fi
    if [ -d "`pwd`/address-model-32/include" ]; then
        CPATH="`pwd`/address-model-32/include${CPATH:+:$CPATH}"
    fi
    export CPATH

    if [ -d "`pwd`/lib" ]; then
        for i in `find "\`pwd\`/lib" -maxdepth 1 -type f \( -name 'lib*.a' -o -name 'lib*.so.*' -executable \)`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LIBRARY_PATH="`pwd`/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/lib32" ]; then
        for i in `find "\`pwd\`/lib32" -maxdepth 1 -type f \( -name 'lib*.a' -o -name 'lib*.so.*' -executable \)`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LIBRARY_PATH="`pwd`/lib32${LIBRARY_PATH:+:$LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/address-model-32/lib" ]; then
        for i in `find "\`pwd\`/address-model-32/lib" -maxdepth 1 -type f \( -name 'lib*.a' -o -name 'lib*.so.*' -executable \)`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LIBRARY_PATH="`pwd`/address-model-32/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"
                break
            fi
        done
    fi
    export LIBRARY_PATH

    if [ -d "`pwd`/lib" ]; then
        for i in `find "\`pwd\`/lib" -maxdepth 1 -type f -name 'lib*.so.*' -executable`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LD_LIBRARY_PATH="`pwd`/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/lib32" ]; then
        for i in `find "\`pwd\`/lib32" -maxdepth 1 -type f -name 'lib*.so.*' -executable`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LD_LIBRARY_PATH="`pwd`/lib32${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/address-model-32/lib" ]; then
        for i in `find "\`pwd\`/address-model-32/lib" -maxdepth 1 -type f -name 'lib*.so.*' -executable`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Intel 80386$'; then
                LD_LIBRARY_PATH="`pwd`/address-model-32/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                break
            fi
        done
    fi
    export LD_LIBRARY_PATH
    true
else
    echo "vars32.sh: should be invoked after \`cd PREFIX'" 1>&2
    false
fi
