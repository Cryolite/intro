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

source "$HOME/.bashrc"

if which date 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: date: command not found" 1>&2
  exit 1
fi

log_file_full_path="$dir/`date +%Y%m%d%H%M%S`.log"

prefix="$HOME/local"

if [ -x "$prefix/bin/twitter.rb" ]; then
  :
else
  echo "$0: error: $prefix/bin/twitter.rb: command not found" 1>&2
  exit 1
fi

if which bjam 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: bjam: command not found" 1>&2
  exit 1
fi

echo -n '========== A scheduled batch build starts here ==========' | "$prefix/bin/twitter.rb"

cd "$dir" && bjam -d+2 --prefix="$prefix" --triplet=x86_64-unknown-linux-gnu --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system                                   --enable-compilers=gcc-previous,gcc-previous-snapshot --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-icu4c=49.1.1 --with-mpi-backend=openmpi --enable-boost --enable-clang --enable-valgrind       --concurrency=3 --with-awacs=\"$prefix/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

cd "$dir" && bjam -d+2 --prefix="$prefix" --triplet=x86_64-unknown-linux-gnu --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system                                   --enable-compilers=gcc-current,gcc-current-snapshot   --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-icu4c=49.1.1 --with-mpi-backend=openmpi --enable-boost --enable-clang --enable-valgrind       --concurrency=3 --with-awacs=\"$prefix/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

cd "$dir" && bjam -d+2 --prefix="$prefix" --triplet=x86_64-unknown-linux-gnu --enable-multitarget --with-binutils=2.22.90 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=latest --with-mpc-for-gcc=latest --with-isl-for-gcc=latest --with-cloog-for-gcc=latest                                   --enable-compilers=gcc-snapshot                       --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-icu4c=49.1.1 --with-mpi-backend=openmpi --enable-boost --enable-clang --enable-valgrind       --concurrency=3 --with-awacs=\"$prefix/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

cd "$dir" && bjam -d+2 --prefix="$prefix" --triplet=x86_64-unknown-linux-gnu --enable-multitarget --with-binutils=2.22.51 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=3.0.1  --with-mpc-for-gcc=latest --with-isl-for-gcc=system --with-cloog-for-gcc=system --with-gcc-for-clang=gcc-current  --enable-compilers=clang-latest                       --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-icu4c=49.1.1 --with-mpi-backend=openmpi --enable-boost                --enable-valgrind=trunk --concurrency=3 --with-awacs=\"$prefix/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

cd "$dir" && bjam -d+2 --prefix="$prefix" --triplet=x86_64-unknown-linux-gnu --enable-multitarget --with-binutils=2.22.90 --with-gmp-for-gcc=latest --with-mpfr-for-gcc=latest --with-mpc-for-gcc=latest --with-isl-for-gcc=latest --with-cloog-for-gcc=latest --with-gcc-for-clang=gcc-snapshot --enable-compilers=clang-trunk                        --enable-gmp --enable-mpfr --enable-mpc --enable-isl --enable-cloog --enable-icu4c=49.1.1 --with-mpi-backend=openmpi --enable-boost                --enable-valgrind=trunk --concurrency=3 --with-awacs=\"$prefix/bin/twitter.rb\" --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1

disk_usage=`df -h ~ | tail --lines=1 | tr --squeeze-repeats ' '`
echo -n "INFO: disk space:"                                              \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=2` total,"  \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=3`"         \
        "(`echo -n $disk_usage | cut --delimiter=' ' --fields=5`) used," \
        "`echo -n $disk_usage | cut --delimiter=' ' --fields=4` free."   \
  | "$prefix/bin/twitter.rb"

echo -n '==========  A scheduled batch build ends here  ==========' | "$prefix/bin/twitter.rb"
