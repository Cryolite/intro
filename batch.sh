#!/usr/bin/env bash

if which dirname 1>/dev/null 2>&1; then
  :
else
  echo "${0}: error: dirname: command not found" 1>&2
  exit 1
fi

if which pwd 1>/dev/null 2>&1; then
  :
else
  echo "${0}: error: pwd: command not found" 1>&2
  exit 1
fi

dir=`(cd \`dirname "${0}"\`; pwd)`
prefix="${HOME}/local"

if [ ! -f "${HOME}/.bashrc" ]; then
  echo "${0}: error: \`${HOME}/.bashrc': command not found" 1>&2
  exit 1
fi

if [ ! -x "${prefix}/bin/twitter.rb" ]; then
  echo "${0}: error: \`${prefix}/bin/twitter.rb': command not found" 1>&2
  exit 1
fi

source "${HOME}/.bashrc"
if [ $? -ne 0 ]; then
  echo "${0}: error: failed to read \`${HOME}/.bashrc'" 1>&2
  echo "${0}: error: failed to read \`${HOME}/.bashrc'" | "${prefix}/bin/twitter.rb"
  exit 1
fi

if which date 1>/dev/null 2>&1; then
  :
else
  echo "${0}: error: date: command not found" 1>&2
  echo "${0}: error: date: command not found" | "${prefix}/bin/twitter.rb"
  exit 1
fi

log_file_full_path="${dir}/`date +%Y%m%d%H%M%S`.log"
if [ $? -ne 0 ]; then
  echo "${0}: error: failed to give a name for a log file" 1>&2
  echo "${0}: error: failed to give a name for a log file" | "${prefix}/bin/twitter.rb"
  exit 1
fi

if which git 1>/dev/null 2>&1; then
  :
else
  echo "${0}: error: git: command not found" 1>&2
  echo "${0}: error: git: command not found" | "${prefix}/bin/twitter.rb"
  exit 1
fi

( cd "${dir}" && git clean -fdx )
if [ $? -ne 0 ]; then
  echo -n "${0}: error: \`git clean' fails" 1>&2
  echo -n "${0}: error: \`git clean' fails" | "${prefix}/bin/twitter.rb"
  exit 1
fi

( cd "${prefix}" && rm -rf gcc-* clang-* icc-* )
if [ $? -ne 0 ]; then
  echo -n "${0}: error: failed to clean up subdirectories under \`prefix'" 1>&2
  echo -n "${0}: error: failed to clean up subdirectories under \`prefix'" | "${prefix}/bin/twitter.rb"
  exit 1
fi

( cd "${prefix}/boost/latest" && rm -rf bin.v2 )
if [ $? -ne 0 ]; then
  echo -n "${0}: error: failed to clean up \`boost/bin.v2' directory" 1>&2
  echo -n "${0}: error: failed to clean up \`boost/bin.v2' directory" | "${prefix}/bin/twitter.rb"
  exit 1
fi

if which bjam 1>/dev/null 2>&1; then
  :
else
  echo "${0}: error: bjam: command not found" 1>&2
  echo "${0}: error: bjam: command not found" | "${prefix}/bin/twitter.rb"
  exit 1
fi

echo -n '========== A scheduled batch build starts here ==========' | "${prefix}/bin/twitter.rb"

# TODO: Add `--enable-boost'.

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=gcc-previous                            --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=gcc-previous-snapshot                   --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=gcc-current                             --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=gcc-current-snapshot                    --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=latest  --with-gmp-for-gcc=latest --with-mpfr-for-gcc=latest --with-mpc-for-gcc=latest --with-isl-for-gcc=latest --with-cloog-for-gcc=latest --enable-compilers=gcc-snapshot                            --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=clang-latest-libstdc++-current          --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                               --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=clang-latest-libstdc++-current-snapshot --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                               --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=latest  --with-gmp-for-gcc=latest --with-mpfr-for-gcc=latest --with-mpc-for-gcc=latest --with-isl-for-gcc=latest --with-cloog-for-gcc=latest --enable-compilers=clang-latest-libstdc++-snapshot         --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                               --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=clang-trunk-libstdc++-current           --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                               --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=clang-trunk-libstdc++-current-snapshot  --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                               --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=latest  --with-gmp-for-gcc=latest --with-mpfr-for-gcc=latest --with-mpc-for-gcc=latest --with-isl-for-gcc=latest --with-cloog-for-gcc=latest --enable-compilers=clang-trunk-libstdc++-snapshot          --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                               --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=icc-system-libstdc++-current            --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --enable-compilers=icc-system-libstdc++-current-snapshot   --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

( cd "${dir}" && bjam -d+2 --prefix="${prefix}" --enable-multitarget --with-binutils=latest  --with-gmp-for-gcc=latest --with-mpfr-for-gcc=latest --with-mpc-for-gcc=latest --with-isl-for-gcc=latest --with-cloog-for-gcc=latest --enable-compilers=icc-system-libstdc++-snapshot           --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-ppl --enable-icu4c --with-mpi-backend=openmpi                --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1 )

disk_usage=`df -h ~ | tail --lines=1 | tr --squeeze-repeats ' '`
echo -n "INFO: disk space:"                                              \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=2` total,"  \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=3`"         \
        "(`echo -n $disk_usage | cut --delimiter=' ' --fields=5`) used," \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=4` free."   \
  | "${prefix}/bin/twitter.rb"

echo -n '==========  A scheduled batch build ends here  ==========' | "${prefix}/bin/twitter.rb"
