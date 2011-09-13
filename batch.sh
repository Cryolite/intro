#!/usr/bin/env bash

prefix="${HOME}/local"
dir="${0%/*}"
export PATH="${prefix}/bin:$PATH"
export BOOST_ROOT="${prefix}/boost/latest"
cd "$dir" && bjam -d+2 --triplet=x86_64-unknown-linux-gnu --prefix="$prefix" --with-mpi=openmpi --concurrency=3 awacs=yes current previous snapshot > $(date +%Y%m%d%H%M%S).log 2>&1
