#!/usr/bin/env sh

intro_root_dir=$1
shift
build_triplet=$1
shift
host_triplet=$1
shift
target_triplet=$1
shift
multitarget=$1
shift
binutils=$1
shift
gmp_for_gcc=$1
shift
mpfr_for_gcc=$1
shift
mpc_for_gcc=$1
shift
isl_for_gcc=$1
shift
cloog_for_gcc=$1
shift
concurrency=$1
shift
gcc_check=$1
shift
awacs=$1
shift
stream=$1
shift
srcdir=$1
shift
objdir=$1
shift
compiler_prefix=$1
shift
compiler_description=$1
shift

echo "intro_root_dir: $intro_root_dir"
echo "build_triplet: $build_triplet"
echo "host_triplet: $host_triplet"
echo "target_triplet: $target_triplet"
echo "multitarget: $multitarget"
echo "binutils: $binutils"
echo "gmp_for_gcc: $gmp_for_gcc"
echo "mpfr_for_gcc: $mpfr_for_gcc"
echo "mpc_for_gcc: $mpc_for_gcc"
echo "isl_for_gcc: $isl_for_gcc"
echo "cloog_for_gcc: $cloog_for_gcc"
echo "concurrency: $concurrency"
echo "gcc_check: $gcc_check"
echo "awacs: $awacs"
echo "stream: $stream"
echo "srcdir: $srcdir"
echo "objdir: $objdir"
echo "compiler_prefix: $compiler_prefix"
echo "compiler_description: $compiler_description"
echo "configure_options: $@"


if [ `echo $binutils `x != x ]; then
    # Create the symlinks to the source directories to GNU Binutils
    # libraries and tools (opcodes, bfd, binutils, gas, ld, gold, gprof) in
    # the GCC source directory.
    ( cd "$srcdir" && ln -sf ../binutils-$binutils/bfd      \
                             ../binutils-$binutils/binutils \
                             ../binutils-$binutils/gas      \
                             ../binutils-$binutils/gold     \
                             ../binutils-$binutils/gprof    \
                             ../binutils-$binutils/ld       \
                             ../binutils-$binutils/opcodes  . ) || exit 1
else
    ( cd "$srcdir" && rm -f bfd binutils gas gold gprof ld opcodes ) || exit 1
fi


# Create the symlink to the GMP source directory.
( cd "$srcdir" && ln -sfT ../gmp-$gmp_for_gcc gmp ) || exit 1


# Create the symlink to the MPFR source directory.
( cd "$srcdir" && ln -sfT ../mpfr-$mpfr_for_gcc mpfr ) || exit 1


# Create the symlink to the MPC source directory.
( cd "$srcdir" && ln -sfT ../mpc-$mpc_for_gcc mpc ) || exit 1


if [ \( `echo $isl_for_gcc `x != x \) -a \( `echo $cloog_for_gcc `x != x \) ]; then
    # Create the symlink to the isl source directory in the GCC source
    # directory.
    ( cd "$srcdir" && ln -sfT ../isl-$isl_for_gcc isl ) || exit 1

    # An ad-hoc workaround that enables the isl configure script to find the
    # GMP build directory during the GCC bootstrap procedure.
    if [ ! -e "$srcdir/isl/real-configure" ]; then
	( cd "$srcdir" && mv isl/configure isl/real-configure ) || exit 1
    fi
    echo '#!/usr/bin/env sh'                                         >  "$srcdir/isl/configure"
    echo ''                                                          >> "$srcdir/isl/configure"
    echo 'echo original options for isl configure script: $@'        >> "$srcdir/isl/configure"
    echo 'dir=`dirname "$0"`'                                        >> "$srcdir/isl/configure"
    echo '"$dir/real-configure"' "--srcdir='$srcdir/isl'"            \
                                 --build=$build_triplet              \
                                 --host=$host_triplet                \
                                 --disable-shared                    \
                                 --enable-static                     \
                                 --with-gmp=build                    \
                                 "--with-gmp-builddir='$objdir/gmp'" >> "$srcdir/isl/configure"
    chmod +x "$srcdir/isl/configure"
else
    # Restore the hacked configure script.
    if [ -e "$srcdir/isl/real-configure" ]; then
	[ ! -x "$srcdir/isl/real-configure" ] && exit 1
	mv -f "$srcdir/isl/real-configure" "$srcdir/isl/configure" || exit 1
    fi
    rm -f "$srcdir/isl"
fi


if [ \( `echo $isl_for_gcc `x != x \) -a \( `echo $cloog_for_gcc `x != x \) ]; then
    # Create the symlink to the CLooG source directory in the GCC source
    # directory.
    ( cd "$srcdir" && ln -sfT ../cloog-$cloog_for_gcc cloog ) || exit 1

    # An ad-hoc workaround that enables the CLooG configure script to find
    # the GMP and isl build directories during the GCC bootstrap procedure.
    if [ ! -e "$srcdir/cloog/real-configure" ]; then
	( cd "$srcdir" && mv cloog/configure cloog/real-configure ) || exit 1
    fi
    echo '#!/usr/bin/env sh'                                         >  "$srcdir/cloog/configure"
    echo ''                                                          >> "$srcdir/cloog/configure"
    echo 'echo original options for CLooG configure script: $@'      >> "$srcdir/cloog/configure"
    echo 'dir=`dirname "$0"`'                                        >> "$srcdir/cloog/configure"
    echo '"$dir/real-configure"' "--srcdir='$srcdir/cloog'"          \
                                 --build=$build_triplet              \
                                 --host=$host_triplet                \
                                 --disable-shared                    \
                                 --enable-static                     \
                                 --with-gmp=build                    \
                                 "--with-gmp-builddir='$objdir/gmp'" \
                                 --with-isl=build                    \
                                 "--with-isl-builddir='$objdir/isl'" \
                                 --with-osl=no                       \
                                 --with-bits=gmp                     >> "$srcdir/cloog/configure"
    chmod +x "$srcdir/cloog/configure"
else
    # Restore the hacked configure script.
    if [ -e "$srcdir/cloog/real-configure" ]; then
	[ ! -x "$srcdir/cloog/real-configure" ] && exit 1
	mv -f "$srcdir/cloog/real-configure" "$srcdir/cloog/configure" || exit 1
    fi
    rm -f "$srcdir/cloog"
fi


[ -x "$srcdir/configure" ] || exit 1
[ -x "$srcdir/config.sub" ] || exit 1
[ `"$srcdir/config.sub" $build_triplet` = $build_triplet ] || exit 1
[ `"$srcdir/config.sub" $host_triplet` = $host_triplet ] || exit 1
[ `"$srcdir/config.sub" $target_triplet` = $target_triplet ] || exit 1


# `configure'.
( cd "$objdir" && "$srcdir/configure" "$@" >> "$stream" 2>&1 )
if [ $? -ne 0 ]; then
    mv "$objdir" "$intro_root_dir/objdir_$$"
    echo    "ERROR:$$: failed to \`configure' ${compiler_description}." 1>&2
    echo -n "ERROR:$$: failed to \`configure' ${compiler_description}." | eval $awacs
    exit 1
fi


# Check the creation of `Makefile'.
[ -f "$objdir/Makefile" ] || exit 1


# `make'.
# isl and CLooG require GMP. However, they will fail to find the GMP
# header files, `<gmp.h>' and `<gmpxx.h>'. `<gmp.h>' will be created in
# `$objdir/gmp' during the bootstrap procedure, whereas `<gmpxx.h>'
# resides in `$srcdir/gmp'. So, `CPATH' environment variable is set
# to include the paths to those header files.
( cd "$objdir" && env CPATH="$objdir/gmp:$srcdir/gmp${CPATH:+:$CPATH}" make --jobs=$concurrency >> "$stream" 2>&1 )
if [ $? -ne 0 ]; then
    mv "$objdir" "$intro_root_dir/objdir_$$"
    echo    "ERROR:$$: failed to \`make' ${compiler_description}." 1>&2
    echo -n "ERROR:$$: failed to \`make' ${compiler_description}." | eval $awacs
    exit 1
fi


if [ "$gcc_check" = 'yes' ]; then
  # `make check'.
  ( cd "$objdir" && make -k check >> "$stream" 2>&1 )
  ( cd "$objdir" && cp 'gcc/testsuite/gcc/gcc.sum' "$compiler_prefix" ) || exit 1
  ( cd "$objdir" && cp 'gcc/testsuite/g++/g++.sum' "$compiler_prefix" ) || exit 1
  ( cd "$objdir" && cp 'x86_64-unknown-linux-gnu/libgomp/testsuite/libgomp.sum' "$compiler_prefix" ) || exit 1
  ( cd "$objdir" && cp 'x86_64-unknown-linux-gnu/libmudflap/testsuite/libmudflap.sum' "$compiler_prefix" ) || exit 1
  ( cd "$objdir" && cp 'x86_64-unknown-linux-gnu/libstdc++-v3/testsuite/libstdc++.sum' "$compiler_prefix" ) || exit 1
fi


# `make install'.
( cd "$objdir" && make install >> "$stream" 2>&1 )
if [ $? -ne 0 ]; then
    mv "$objdir" "$intro_root_dir/objdir_$$"
    echo    "ERROR:$$: failed to \`make install' ${compiler_description}." 1>&2
    echo -n "ERROR:$$: failed to \`make install' ${compiler_description}." | eval $awacs
    exit 1
fi


# A workaround. Create a symlink to `ld' in the directory where the installed
# GCC front end searches for subprograms.
( cd "$compiler_prefix/libexec/gcc/${host_triplet}/`"$compiler_prefix/bin/gcc" -dumpversion`" && ln -sf ../../../../bin/ld real-ld )
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to create the workaround symlink to the linker for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to create the workaround symlink to the linker for ${compiler_description}." | eval $awacs
    exit 1
fi

# Some configure scripts (e.g. MPC's) require `ld' instead of `real-ld'.
( cd "$compiler_prefix/libexec/gcc/${host_triplet}/`"$compiler_prefix/bin/gcc" -dumpversion`" && ln -sf ../../../../bin/ld ld )
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to create the workaround symlink to the linker for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to create the workaround symlink to the linker for ${compiler_description}." | eval $awacs
    exit 1
fi


# Install the modified specfile and wrapper scripts.
install --mode=755 "${intro_root_dir}/template/${host_triplet}/vars64.sh" "${compiler_prefix}/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install \`vars64.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to install \`vars64.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." | eval $awacs
    exit 1
fi
install --mode=755 "${intro_root_dir}/template/${host_triplet}/vars64debug.sh" "${compiler_prefix}/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install \`vars64debug.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to install \`vars64debug.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." | eval $awacs
    exit 1
fi
install --mode=755 "${intro_root_dir}/template/${host_triplet}/vars32.sh" "${compiler_prefix}/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install \`vars32.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to install \`vars32.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." | eval $awacs
    exit 1
fi
install --mode=755 "${intro_root_dir}/template/${host_triplet}/vars32debug.sh" "${compiler_prefix}/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install \`vars32debug.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to install \`vars32debug.sh' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." | eval $awacs
    exit 1
fi
install --mode=755 "${intro_root_dir}/template/${host_triplet}/hack-gcc-specs" "${compiler_prefix}/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install the modified specfile for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to install the modified specfile for ${compiler_description}." | eval $awacs
    exit 1
fi
install --mode=755 "${intro_root_dir}/template/${host_triplet}/gcc-wrapper" "${compiler_prefix}/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install \`gcc-wrapper' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to install \`gcc-wrapper' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." | eval $awacs
    exit 1
fi
install --mode=755 "${intro_root_dir}/template/${host_triplet}/g++-wrapper" "${compiler_prefix}/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install \`g++-wrapper' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." 1>&2
    echo -n "ERROR: failed to install \`g++-wrapper' wrapper script to \`${compiler_prefix}/bin' for ${compiler_description}." | eval $awacs
    exit 1
fi
