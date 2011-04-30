#!/usr/bin/env sh

version=$1
[ ! -n "$version" ] && exit 1
build=$2
[ ! -n "$build" ] && exit 1
host=$3
[ ! -n "$host" ] && exit 1
target=$4
[ ! -n "$target" ] && exit 1
prefix=$5
[ ! -n "$prefix" ] && exit 1
check=$6
[ ! -n "$check" ] && exit 1
default=$7
[ ! -n "$default" ] && exit 1

if [ $target = $host -a $host = $build ]; then
    { (LC_ALL=C "$prefix/bin/gcc-$version" -v 2>&1) || exit $?; } \
	| { grep -Eq "^Target: $target\$" || exit $?; }
    { (LC_ALL=C "$prefix/bin/gcc-$version" -v 2>&1) || exit $?; } \
	| { grep -Eq "^gcc version $version" || exit $?; }
elif [ $target != $host ]; then
    if [ $default = yes ]; then
	{ (LC_ALL=C "$prefix/bin/$target-gcc" -v 2>&1) || exit $?; } \
	    | { grep -Eq "^Target: $target\$" || exit $?; }
	{ (LC_ALL=C "$prefix/bin/$target-gcc" -v 2>&1) || exit $?; } \
	    | { grep -Eq "^gcc version $version" || exit $?; }
    elif [ $default = no ]; then
	{ (LC_ALL=C "$prefix/bin/$target-gcc-$version" -v 2>&1) || exit $?; } \
	    | { grep -Eq "^Target: $target\$" || exit $?; }
	{ (LC_ALL=C "$prefix/bin/$target-gcc-$version" -v 2>&1) || exit $?; } \
	    | { grep -Eq "^gcc version $version" || exit $?; }
    else
	exit 1
    fi
else
    if [ $check = yes ]; then
	if [ $default = yes ]; then
	    { (LC_ALL=C "$prefix/$host/bin/gcc" -v 2>&1) || exit $?; } \
		| { grep -Eq "^Target: $target\$" || exit $?; }
	    { (LC_ALL=C "$prefix/$host/bin/gcc" -v 2>&1) || exit $?; } \
		| { grep -Eq "^gcc version $version" || exit $?; }
	elif [ $default = no ]; then
	    { (LC_ALL=C "$prefix/$host/bin/gcc-$version" -v 2>&1) || exit $?; } \
		| { grep -Eq "^Target: $target\$" || exit $?; }
	    { (LC_ALL=C "$prefix/$host/bin/gcc-$version" -v 2>&1) || exit $?; } \
		| { grep -Eq "^gcc version $version" || exit $?; }
	else
	    exit 1
	fi
    else
	if [ $default = yes ]; then
	    [ ! -f "$prefix/bin/gcc" -a ! -f "$prefix/bin/gcc.exe" ] && exit 1
	elif [ $default = no ]; then
	    [ ! -f "$prefix/bin/gcc-$version" -a ! -f "$prefix/bin/gcc-$version.exe" ] && exit 1
	else
	    exit 1
	fi
    fi
fi

exit 0
