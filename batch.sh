#!/usr/bin/env sh

if which dirname 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: dirname: command not found" 1>&2
  exit 1
fi

if which pwd 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: pwd: command not found" 1>&2
  exit 1
fi

dir=`(cd \`dirname "$0"\`; pwd)`

source ${HOME}/.bashrc

if which date 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: date: command not found" 1>&2
  exit 1
fi

log_file_full_path=${dir}/`date +%Y%m%d%H%M%S`.log

prefix="${HOME}/local"

if [ -x "${prefix}/bin/twitter.rb" ]; then
  :
else
  echo "$0: error: ${prefix}/bin/twitter.rb: command not found" 1>&2
  exit 1
fi

if which bjam 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: bjam: command not found" 1>&2
  exit 1
fi

echo -n '========== A scheduled batch build starts here ==========' | "${prefix}/bin/twitter.rb"

cd "$dir" && bjam -d+2 --triplet=x86_64-unknown-linux-gnu --prefix="$prefix" --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1 --with-mpc-for-gcc=latest --with-ppl-for-gcc=0.11.2 --with-cloog-for-gcc=latest                                   --enable-compilers=gcc-previous,gcc-previous-snapshot --disable-multilib --enable-gmp --enable-mpfr --enable-mpc --enable-ppl --enable-cloog --with-icu4c=49.1.1 --with-mpi=openmpi --enable-boost --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

cd "$dir" && bjam -d+2 --triplet=x86_64-unknown-linux-gnu --prefix="$prefix" --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1 --with-mpc-for-gcc=latest --with-ppl-for-gcc=latest --with-cloog-for-gcc=latest                                   --enable-compilers=gcc-current,gcc-current-snapshot   --disable-multilib --enable-gmp --enable-mpfr --enable-mpc --enable-ppl --enable-cloog --with-icu4c=49.1.1 --with-mpi=openmpi --enable-boost --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

cd "$dir" && bjam -d+2 --triplet=x86_64-unknown-linux-gnu --prefix="$prefix" --with-binutils=2.22.52 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1 --with-mpc-for-gcc=latest --with-ppl-for-gcc=latest --with-cloog-for-gcc=latest --with-gcc-for-clang=gcc-snapshot --enable-compilers=gcc-snapshot,clang-trunk           --disable-multilib --enable-gmp --enable-mpfr --enable-mpc --enable-ppl --enable-cloog --with-icu4c=49.1.1 --with-mpi=openmpi --enable-boost --enable-clang --enable-valgrind --concurrency=3 --with-awacs=\"${prefix}/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

disk_usage=`df -h ~ | tail --lines=1 | tr --squeeze-repeats ' '`
echo -n "INFO: disk space:"                                              \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=2` total,"  \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=3`"         \
        "(`echo -n $disk_usage | cut --delimiter=' ' --fields=5`) used," \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=4` free."   \
  | "${prefix}/bin/twitter.rb"

echo -n '==========  A scheduled batch build ends here  ==========' | "${prefix}/bin/twitter.rb"
