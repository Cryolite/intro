#!/bin/sh

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

if which date 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: date: command not found" 1>&2
  exit 1
fi

log_file_full_path=${dir}/`date +%Y%m%d%H%M%S`.log

prefix="${HOME}/local"

if which bjam 1>/dev/null 2>&1; then
  :
else
  echo "$0: error: bjam: command not found" 1>&2
  exit 1
fi

cd "$dir" && bjam -d+2 --triplet=i686-pc-cygwin --prefix="$prefix" --with-binutils=system --with-mpfr-for-gcc=3.0.1 --with-ppl-for-gcc=system --with-cloog-for-gcc=system --with-gcc-for-clang=gcc-snapshot --enable-compilers=gcc-current --disable-multilib --enable-gmp --enable-mpfr --with-mpi=mpich2 --enable-boost --enable-clang --concurrency=2 --with-stream="$log_file_full_path" >> "$log_file_full_path" 2>&1
