#!/usr/bin/env bash

dir="${0%/*}"
if [ "$dir" != "." ]; then
    dir="$(dirname "$0")"
    if [ "$dir" = "." ]; then
	echo "ERROR: this script should be called by the command containing the directory separator '/'." 1>&2
	exit 1
    fi
fi
dir="$(cd "$dir"; pwd)"

source ${HOME}/.bashrc

prefix="${HOME}/local"
log_file_full_path=${dir}/$(date +%Y%m%d%H%M%S).log

echo -n '========== A scheduled batch build starts here ==========' | "${prefix}/bin/twitter.rb"

cd "$dir" && bjam -d+2 --triplet=x86_64-unknown-linux-gnu --prefix="$prefix" --with-binutils-for-gcc=2.22.52 --with-mpfr-for-gcc=3.0.1 --with-ppl-for-gcc=0.11.2 --enable-gcc-versions=gcc-previous,gcc-previous-snapshot,gcc-current,gcc-current-snapshot,gcc-snapshot --disable-multilib --enable-gmp --enable-mpfr --enable-mpc --enable-ppl --enable-cloog --with-mpi=openmpi --enable-clang --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

disk_usage=$(df -h ~ | tail --lines=1 | tr --squeeze-repeats ' ')
echo -n "INFO: disk space:"                                               \
        "$(echo -n $disk_usage | cut --delimiter=' ' --fields=2) total,"  \
        "$(echo -n $disk_usage | cut --delimiter=' ' --fields=3)"         \
        "($(echo -n $disk_usage | cut --delimiter=' ' --fields=5)) used," \
        "$(echo -n $disk_usage | cut --delimiter=' ' --fields=4) free."   \
  | "${prefix}/bin/twitter.rb"

echo -n '==========  A scheduled batch build ends here  ==========' | "${prefix}/bin/twitter.rb"
