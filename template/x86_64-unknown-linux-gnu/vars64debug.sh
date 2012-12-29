#!/usr/bin/env sh

. "bin/vars64.sh"

if [ $? -eq 0 -a -e "`pwd`/bin/vars64debug.sh" ]; then
    if [ -d "`pwd`/lib/debug" ]; then
        for i in `find "\`pwd\`/lib/debug" -maxdepth 1 -type f \( -name 'lib*.a' -o -name 'lib*.so.*' -executable \)`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Advanced Micro Devices X86-64$'; then
                LIBRARY_PATH="`pwd`/lib/debug${LIBRARY_PATH:+:$LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/lib64/debug" ]; then
        for i in `find "\`pwd\`/lib64/debug" -maxdepth 1 -type f \( -name 'lib*.a' -o -name 'lib*.so.*' -executable \)`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Advanced Micro Devices X86-64$'; then
                LIBRARY_PATH="`pwd`/lib64/debug${LIBRARY_PATH:+:$LIBRARY_PATH}"
                break
            fi
        done
    fi
    export LIBRARY_PATH

    if [ -d "`pwd`/lib/debug" ]; then
        for i in `find "\`pwd\`/lib/debug" -maxdepth 1 -type f -name 'lib*.so.*' -executable`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Advanced Micro Devices X86-64$'; then
                LD_LIBRARY_PATH="`pwd`/lib/debug${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                break
            fi
        done
    fi
    if [ -d "`pwd`/lib64/debug" ]; then
        for i in `find "\`pwd\`/lib64/debug" -maxdepth 1 -type f -name 'lib*.so.*' -executable`; do
            if readelf -h "$i" | grep -Eq '^[[:space:]]+Machine:[[:space:]]+Advanced Micro Devices X86-64$'; then
                LD_LIBRARY_PATH="`pwd`/lib64/debug${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                break
            fi
        done
    fi
    export LD_LIBRARY_PATH
    true
else
    echo "vars64debug.sh: should be invoked after \`cd PREFIX'" 1>&2
    false
fi
