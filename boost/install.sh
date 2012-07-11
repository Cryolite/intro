#!/usr/bin/env sh

triplet=$1
shift
compiler_description=$1
shift
is_gcc=$1
shift
is_clang=$1
shift
version=$1
shift
concurrency=$1
shift
awacs=$1
shift
stream=$1
shift
boost_root=$1
shift

echo "triplet: $triplet"
echo "compiler_description: $compiler_description"
echo "is_gcc: $is_gcc"
echo "is_clang: $is_clang"
echo "version: $version"
echo "concurrency: $concurrency"
echo "awacs: $awacs"
echo "stream: $stream"
echo "boost_root: $boost_root"
echo "options: $@"


if [ ! -x "$boost_root/b2" ]; then
    echo    "ERROR: Boost $version not found ($compiler_description, $triplet)." 1>&2
    echo -n "ERROR: Boost $version not found ($compiler_description, $triplet)." | eval $awacs
    exit 1
fi


result=0


# Build debug version libraries.
if [ -n "$stream" ]; then
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" $@ >> "$stream" 2>&1 )
else
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" $@ )
fi
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to build Boost $version (debug build) ($compiler_description, $triplet)." 1>&2
    echo -n "ERROR: failed to build Boost $version (debug build) ($compiler_description, $triplet)." | eval $awacs
    result=1
fi


if [ $is_gcc -ne 0 ]; then
    # Build debug version libraries with mudflap.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug link=static runtime-link=shared cxxflags="-std=c++0x" mudflap=on $@ --buildid=mf >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug link=static runtime-link=shared cxxflags="-std=c++0x" mudflap=on $@ --buildid=mf )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (debug build with mudflap) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (debug build with mudflap) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
elif [ $is_clang -ne 0 ]; then
    # Build debug version libraries with AddressSanitizer.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" address-sanitizer=on $@ --buildid=as >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" address-sanitizer=on $@ --buildid=as )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (debug build with AddressSanitizer) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (debug build with AddressSanitizer) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
else
    echo "ERROR: unknown compiler" 1>&2
    exit 1
fi


# Build debug version libraries with libstdc++ debug mode.
if [ -n "$stream" ]; then
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" libstdc++-debug-mode=on $@ --buildid=dm >> "$stream" 2>&1 )
else
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" libstdc++-debug-mode=on $@ --buildid=dm )
fi
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to build Boost $version (debug build with libstdc++ debug mode) ($compiler_description, $triplet)." 1>&2
    echo -n "ERROR: failed to build Boost $version (debug build with libstdc++ debug mode) ($compiler_description, $triplet)." | eval $awacs
    result=1
fi


if [ $is_gcc -ne 0 ]; then
    # Build debug version libraries with mudflap and libstdc++ debug mode.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug link=static runtime-link=shared cxxflags="-std=c++0x" mudflap=on libstdc++-debug-mode=on $@ --buildid=mf-dm >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug link=static runtime-link=shared cxxflags="-std=c++0x" mudflap=on libstdc++-debug-mode=on $@ --buildid=mf-dm )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (debug build with mudflap and libstdc++ debug mode) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (debug build with mudflap and libstdc++ debug mode) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
elif [ $is_clang -ne 0 ]; then
    # Build debug version libraries with AddressSanitizer and libstdc++ debug mode.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" address-sanitizer=on libstdc++-debug-mode=on $@ --buildid=as-dm >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=debug runtime-link=shared cxxflags="-std=c++0x" address-sanitizer=on libstdc++-debug-mode=on $@ --buildid=as-dm )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (debug build with AddressSanitizer and libstdc++ debug mode) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (debug build with AddressSanitizer and libstdc++ debug mode) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
else
    echo "ERROR: unknown compiler" 1>&2
    exit 1
fi


# Build release version libraries with LTO options.
if [ -n "$stream" ]; then
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" cflags=-flto linkflags=-O3 linkflags=-flto $@ >> "$stream" 2>&1 )
else
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" cflags=-flto linkflags=-O3 linkflags=-flto $@ )
fi
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to build Boost $version (release build with LTO support) ($compiler_description, $triplet)." 1>&2
    echo -n "ERROR: failed to build Boost $version (release build with LTO support) ($compiler_description, $triplet)." | eval $awacs
    result=1
fi


if [ $is_gcc -ne 0 ]; then
    # Build release version libraries with mudflap.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release link=static runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on mudflap=on $@ --buildid=mf >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release link=static runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on mudflap=on $@ --buildid=mf )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (release build with mudflap) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (release build with mudflap) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
elif [ $is_clang -ne 0 ]; then
    # Build release version libraries with AddressSanitizer.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on address-sanitizer=on $@ --buildid=as >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on address-sanitizer=on $@ --buildid=as )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (release build with AddressSanitizer) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (release build with AddressSanitizer) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
else
    echo "ERROR: unknown compiler" 1>&2
    exit 1
fi


# Build release version libraries with libstdc++ debug mode.
if [ -n "$stream" ]; then
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on libstdc++-debug-mode=on $@ --buildid=dm >> "$stream" 2>&1 )
else
    ( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on libstdc++-debug-mode=on $@ --buildid=dm )
fi
if [ $? -ne 0 ]; then
    echo    "ERROR: failed to build Boost $version (release build with libstdc++ debug mode) ($compiler_description, $triplet)." 1>&2
    echo -n "ERROR: failed to build Boost $version (release build with libstdc++ debug mode) ($compiler_description, $triplet)." | eval $awacs
    result=1
fi


if [ $is_gcc -ne 0 ]; then
    # Build release version libraries with mudflap and libstdc++ debug mode.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release link=static runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on mudflap=on libstdc++-debug-mode=on $@ --buildid=mf-dm >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release link=static runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on mudflap=on libstdc++-debug-mode=on $@ --buildid=mf-dm )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (release build with mudflap and libstdc++ debug mode) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (release build with mudflap and libstdc++ debug mode) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
elif [ $is_clang -ne 0 ]; then
    # Build release version libraries with AddressSanitizer and libstdc++ debug mode.
    if [ -n "$stream" ]; then
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on address-sanitizer=on libstdc++-debug-mode=on $@ --buildid=as-dm >> "$stream" 2>&1 )
    else
	( cd "$boost_root" && ./b2 -d+2 -j$concurrency variant=release runtime-link=shared cxxflags="-std=c++0x" debug-symbols=on correct-call-stack=on address-sanitizer=on libstdc++-debug-mode=on $@ --buildid=as-dm )
    fi
    if [ $? -ne 0 ]; then
	echo    "ERROR: failed to build Boost $version (release build with AddressSanitizer and libstdc++ debug mode) ($compiler_description, $triplet)." 1>&2
	echo -n "ERROR: failed to build Boost $version (release build with AddressSanitizer and libstdc++ debug mode) ($compiler_description, $triplet)." | eval $awacs
	result=1
    fi
else
    echo "ERROR: unknown compiler" 1>&2
    exit 1
fi

exit $result
