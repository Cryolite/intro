#!/usr/bin/env bash

dir="${0%/*}"
if [ "$dir" != "." ]; then
    dir="$(dirname "$0")"
    if [ "$dir" = "." ]; then
	echo "ERROR: this script should be called by the command containing '/'." 1>&2
	exit 1
    fi
fi
dir="$(cd "$dir"; pwd)"

prefix="${HOME}/local"
export PATH="${prefix}/bin${PATH:+:$PATH}"
export BOOST_ROOT="${prefix}/boost/latest"
cd "$dir" && bjam -d+2 --triplet=x86_64-unknown-linux-gnu --prefix="$prefix" --enable-multilib --with-mpi=openmpi --enable-clang --concurrency=3 --enable-awacs=\"${prefix}/sbin/twitter.rb\" builtin current previous oldest snapshot > $(date +%Y%m%d%H%M%S).log 2>&1
