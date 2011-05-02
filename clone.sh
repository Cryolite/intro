#!/usr/bin/env sh

ln -f stage1/binutils/jamfile          stage2/binutils/jamfile
ln -f stage1/gcc/jamfile               stage2/gcc/jamfile
ln -f stage1/gmp/jamfile               stage2/gmp/jamfile
ln -f stage1/mingw-w64-crt/jamfile     stage2/mingw-w64-crt/jamfile
ln -f stage1/mingw-w64-headers/jamfile stage2/mingw-w64-headers/jamfile
ln -f stage1/mpc/jamfile               stage2/mpc/jamfile
ln -f stage1/mpfr/jamfile              stage2/mpfr/jamfile

ln -f stage1/binutils/jamfile          stage3/binutils/jamfile
ln -f stage1/gcc/jamfile               stage3/gcc/jamfile
ln -f stage1/gmp/jamfile               stage3/gmp/jamfile
ln -f stage1/mingw-w64-crt/jamfile     stage3/mingw-w64-crt/jamfile
ln -f stage1/mingw-w64-headers/jamfile stage3/mingw-w64-headers/jamfile
ln -f stage1/mpc/jamfile               stage3/mpc/jamfile
ln -f stage1/mpfr/jamfile              stage3/mpfr/jamfile
