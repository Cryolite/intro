#!/usr/bin/env sh

intro_root_dir=$1
shift
triplet=$1
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
libdir=$1
shift

echo "intro_root_dir: $intro_root_dir"
echo "triplet: $triplet"
echo "multitarget: $multitarget"
echo "binutils: $binutils"
echo "gmp_for_gcc: $gmp_for_gcc"
echo "mpfr_for_gcc: $mpfr_for_gcc"
echo "mpc_for_gcc: $mpc_for_gcc"
echo "isl_for_gcc: $isl_for_gcc"
echo "cloog_for_gcc: $cloog_for_gcc"
echo "concurrency: $concurrency"
echo "awacs: $awacs"
echo "stream: $stream"
echo "srcdir: $srcdir"
echo "objdir: $objdir"
echo "compiler_prefix: $compiler_prefix"
echo "compiler_description: $compiler_description"
echo "libdir: $libdir"
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


if [ \( `echo $ppl_for_gcc `x != x \) -a \( `echo $cloog_for_gcc `x != x \) ]; then
    # An ad-hoc workaround that forces the GCC bootstrap procedure to build
    # GMP C++ bindings, which are necessary to build PPL.
    if [ ! -e "$srcdir/gmp/real-configure" ]; then
	( cd "$srcdir" && mv gmp/configure gmp/real-configure ) || exit 1
    fi
    echo '#!/usr/bin/env sh'                                  >  "$srcdir/gmp/configure"
    echo ''                                                   >> "$srcdir/gmp/configure"
    echo 'echo original options for GMP configure script: $@' >> "$srcdir/gmp/configure"
    echo 'dir=`dirname "$0"`'                                 >> "$srcdir/gmp/configure"
    echo '"$dir/real-configure"' "--srcdir='$srcdir/gmp'"     \
                                 --build=$triplet             \
                                 --host=$triplet              \
                                 --enable-cxx                 \
                                 --disable-shared             \
                                 --enable-static              >> "$srcdir/gmp/configure"
    chmod +x "$srcdir/gmp/configure"
else
    # Restore the hacked configure script.
    if [ -e "$srcdir/gmp/real-configure" ]; then
	[ ! -x "$srcdir/gmp/real-configure" ] && exit 1
	mv -f "$srcdir/gmp/real-configure" "$srcdir/gmp/configure" || exit 1
    fi
fi


# Create the symlink to the MPFR source directory.
( cd "$srcdir" && ln -sfT ../mpfr-$mpfr_for_gcc mpfr ) || exit 1


# Create the symlink to the MPC source directory.
( cd "$srcdir" && ln -sfT ../mpc-$mpc_for_gcc mpc ) || exit 1


if [ \( `echo $ppl_for_gcc `x != x \) -a \( `echo $cloog_for_gcc `x != x \) ]; then
    # Create the symlink to the PPL source directory in the GCC source
    # directory.
    ( cd "$srcdir" && ln -sfT ../ppl-$ppl_for_gcc ppl ) || exit 1

    # An ad-hoc workaround that enables the PPL configure script to find the
    # GMP build directory during the GCC bootstrap procedure.
    if [ ! -e "$srcdir/ppl/real-configure" ]; then
	( cd "$srcdir" && mv ppl/configure ppl/real-configure ) || exit 1
    fi
    echo '#!/usr/bin/env sh'                                      >  "$srcdir/ppl/configure"
    echo ''                                                       >> "$srcdir/ppl/configure"
    echo 'echo original options for PPL configure script: $@'     >> "$srcdir/ppl/configure"
    echo 'dir=`dirname "$0"`'                                     >> "$srcdir/ppl/configure"
    echo '"$dir/real-configure"' "--srcdir='$srcdir/ppl'"         \
                                 --build=$triplet                 \
                                 --host=$triplet                  \
                                 --disable-shared                 \
                                 --enable-static                  \
                                 "--with-gmp-build='$objdir/gmp'" >> "$srcdir/ppl/configure"
    chmod +x "$srcdir/ppl/configure"
else
    # Restore the hacked configure script.
    if [ -e "$srcdir/ppl/real-configure" ]; then
	[ ! -x "$srcdir/ppl/real-configure" ] && exit 1
	mv -f "$srcdir/ppl/real-configure" "$srcdir/ppl/configure" || exit 1
    fi
    rm -f "$srcdir/ppl"
fi


if [ \( `echo $ppl_for_gcc `x != x \) -a \( `echo $cloog_for_gcc `x != x \) ]; then
    # Create the symlink to the CLooG source directory in the GCC source
    # directory.
    ( cd "$srcdir" && ln -sfT ../cloog-$cloog_for_gcc cloog ) || exit 1

    # An ad-hoc workaround that enables the CLooG configure script to find
    # the GMP build directory during the GCC bootstrap procedure.
    if [ ! -e "$srcdir/cloog/real-configure" ]; then
	( cd "$srcdir" && mv cloog/configure cloog/real-configure ) || exit 1
    fi
    echo '#!/usr/bin/env sh'                                         >  "$srcdir/cloog/configure"
    echo ''                                                          >> "$srcdir/cloog/configure"
    echo 'echo original options for CLooG configure script: $@'      >> "$srcdir/cloog/configure"
    echo 'dir=`dirname "$0"`'                                        >> "$srcdir/cloog/configure"
    echo '"$dir/real-configure"' "--srcdir='$srcdir/cloog'"          \
                                 --build=$triplet                    \
                                 --host=$triplet                     \
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
[ `"$srcdir/config.sub" $triplet` = $triplet ] || exit 1


# `configure'.
if [ -n "$stream" ]; then
    ( cd "$objdir" && env LD_RUN_PATH="$libdir${LD_RUN_PATH:+:$LD_RUN_PATH}" "$srcdir/configure" "$@" >> "$stream" 2>&1 )
else
    ( cd "$objdir" && env LD_RUN_PATH="$libdir${LD_RUN_PATH:+:$LD_RUN_PATH}" "$srcdir/configure" "$@" )
fi
if [ $? -ne 0 ]; then
    mv "$objdir" "$intro_root_dir/objdir_$$"
    echo    "ERROR:$$: failed to \`configure' $compiler_description ($triplet)." 1>&2
    echo -n "ERROR:$$: failed to \`configure' $compiler_description ($triplet)." | eval $awacs
    exit 1
fi


# Check the creation of `Makefile'.
[ -f "$objdir/Makefile" ] || exit 1


# PPL and CLooG requires GMP. However, they will fail to find the GMP
# header files, `<gmp.h>' and `<gmpxx.h>'. `<gmp.h>' will be created in
# `objdir/gmp' during the bootstrap procedure, whereas `<gmpxx.h>'
# resides in `srcdir/gmp'. So, `CPATH' environment variable is set
# to include the paths to those header files.
env_for_make = "CPATH=$objdir/gmp:$srcdir/gmp${CPATH:+:$CPATH}"                                                        \
               "LIBRARY_PATH=$objdir/gmp/.libs:$objdir/$triplet/libstdc++-v3/src/.libs${LIBRARY_PATH:+:$LIBRARY_PATH}" \
               "LD_RUN_PATH=$libdir${LD_RUN_PATH:+:$LD_RUN_PATH}"
if [ -n "$stream" ]; then
    ( cd "$objdir" && env $env_for_make make --jobs=$concurrency >> "$stream" 2>&1 )
    if [ $? -ne 0 ]; then
	( cd "$objdir" && env $env_for_make make --jobs=$concurrency >> "$stream" 2>&1 )
	if [ $? -ne 0 ]; then
            ( cd "$objdir" && env $env_for_make make --jobs=$concurrency >> "$stream" 2>&1 )
	fi
    fi
else
    ( cd "$objdir" && env $env_for_make make --jobs=$concurrency )
    if [ $? -ne 0 ]; then
	( cd "$objdir" && env $env_for_make make --jobs=$concurrency )
	if [ $? -ne 0 ]; then
            ( cd "$objdir" && env $env_for_make make --jobs=$concurrency )
	fi
    fi
fi
if [ $? -ne 0 ]; then
    mv "$objdir" "$intro_root_dir/objdir_$$"
    echo    "ERROR:$$: failed to \`make' $compiler_description ($triplet)." 1>&2
    echo -n "ERROR:$$: failed to \`make' $compiler_description ($triplet)." | eval $awacs
    exit 1
fi


# `make install'.
if [ -n "$stream" ]; then
    ( cd "$objdir" && env LD_RUN_PATH="$libdir${LD_RUN_PATH:+:$LD_RUN_PATH}" make install >> "$stream" 2>&1 )
else
    ( cd "$objdir" && env LD_RUN_PATH="$libdir${LD_RUN_PATH:+:$LD_RUN_PATH}" make install )
fi
if [ $? -ne 0 ]; then
    mv "$objdir" "$intro_root_dir/objdir_$$"
    echo    "ERROR:$$: failed to \`make install' $compiler_description ($triplet)." 1>&2
    echo -n "ERROR:$$: failed to \`make install' $compiler_description ($triplet)." | eval $awacs
    exit 1
fi


# A workaround. Create a symlink to `ld' in the directory where the installed
# GCC front end searches for subprograms.
( cd "$compiler_prefix/libexec/gcc/$triplet/`"$compiler_prefix/bin/gcc" -dumpversion`" && ln -sf ../../../../bin/ld real-ld )
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to create the workaround symlink to the linker for $compiler_description ($triplet)." 1>&2
    echo -n "ERROR: failed to create the workaround symlink to the linker for $compiler_description ($triplet)." | eval $awacs
    exit 1
fi

# Some configure scripts (e.g. MPC's) require `ld' instead of `real-ld'.
( cd "$compiler_prefix/libexec/gcc/$triplet/`"$compiler_prefix/bin/gcc" -dumpversion`" && ln -sf ../../../../bin/ld ld )
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to create the workaround symlink to the linker for $compiler_description ($triplet)." 1>&2
    echo -n "ERROR: failed to create the workaround symlink to the linker for $compiler_description ($triplet)." | eval $awacs
    exit 1
fi


# Install the modified specfile and wrapper scripts.
install --mode=755 "$intro_root_dir/template/$triplet/hack-gcc-specs" "$compiler_prefix/bin"
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to install the modified specfile for $compiler_description ($triplet)." 1>&2
    echo -n "ERROR: failed to install the modified specfile for $compiler_description ($triplet)." | eval $awacs
    exit 1
fi
if [ $multitarget = yes ]; then
    install --mode=755 "$intro_root_dir/template/$triplet/gcc-wrapper-64" "$compiler_prefix/bin/gcc-wrapper"
    if [ $? -ne 0 ]; then
        echo    "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." 1>&2
        echo -n "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." | eval $awacs
        exit 1
    fi
    install --mode=755 "$intro_root_dir/template/$triplet/gcc-wrapper-32" "$compiler_prefix/bin/gcc-wrapper-32"
    if [ $? -ne 0 ]; then
        echo    "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." 1>&2
        echo -n "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." | eval $awacs
        exit 1
    fi
    install --mode=755 "$intro_root_dir/template/$triplet/g++-wrapper-64" "$compiler_prefix/bin/g++-wrapper"
    if [ $? -ne 0 ]; then
        echo    "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." 1>&2
        echo -n "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." | eval $awacs
        exit 1
    fi
    install --mode=755 "$intro_root_dir/template/$triplet/g++-wrapper-32" "$compiler_prefix/bin/g++-wrapper-32"
    if [ $? -ne 0 ]; then
        echo    "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." 1>&2
        echo -n "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." | eval $awacs
        exit 1
    fi
else
    install --mode=755 "$intro_root_dir/template/$triplet/gcc-wrapper" "$intro_root_dir/template/$triplet/g++-wrapper" "$compiler_prefix/bin"
    if [ $? -ne 0 ]; then
        echo    "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." 1>&2
        echo -n "ERROR: failed to install the wrapper scripts for $compiler_description ($triplet)." | eval $awacs
        exit 1
    fi
fi
