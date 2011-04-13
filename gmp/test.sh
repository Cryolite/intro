#!/usr/bin/env sh

version=$1
[ ! -n "$version" ] && exit 1
build=$2
[ ! -n "$build" ] && exit 1
host=$3
[ ! -n "$host" ] && exit 1
abi=$4
[ ! -n "$abi" ] && exit 1
prefix=$5
[ ! -n "$prefix" ] && exit 1
check=$6
[ ! -n "$check" ] && exit 1

cc=`"${0%/*}/../cc.sh" $build $host $abi` || exit 1

x=`/bin/echo -e -n '#include <gmp.h>\n__GNU_MP_VERSION\n__GNU_MP_VERSION_MINOR\n__GNU_MP_VERSION_PATCHLEVEL' \
    | { $cc -E -I"${prefix}/include" -x c - || exit 1; } \
    | { tail --lines=3 || exit 1; } \
    | { tr '\n' '.' || exit 1; } \
    | { grep -Eo '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
y=`/bin/echo -e -n "$version\n$x" | { sort --version-sort || exit 1; } | { tail --lines=1 || exit 1; }`
[ $y != $x ] && { /bin/echo -n 'no'; exit 0; }

source=`tempfile --suffix .c` || exit 1
cat >"$source" <<EOT
#include <gmp.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  int i = -1, j = -1, k = -1;
  if (sscanf("${version}.0.0", "%d%*c%d%*c%d", &i, &j, &k) != 3) {
    return EXIT_FAILURE;
  }
  if (__GNU_MP_VERSION < i) {
    return EXIT_FAILURE;
  }
  if (__GNU_MP_VERSION == i) {
    if (__GNU_MP_VERSION_MINOR < j) {
      return EXIT_FAILURE;
    }
    if (__GNU_MP_VERSION_MINOR == j) {
      if (__GNU_MP_VERSION_PATCHLEVEL < k) {
        return EXIT_FAILURE;
      }
    }
  }

  i = -1; j = -1; k = -1;
  char c = 0, d = 0;
  int result = sscanf(gmp_version, "%d%c%d%c%d", &i, &c, &j, &d, &k);
  if (c != '.') {
    if (result < 2) {
      return EXIT_FAILURE;
    }
    j = 0; k = 0;
  }
  else if (d != '.') {
    if (result < 4) {
      return EXIT_FAILURE;
    }
    k = 0;
  }
  if (i != __GNU_MP_VERSION
        || j != __GNU_MP_VERSION_MINOR
        || k != __GNU_MP_VERSION_PATCHLEVEL)
  {
    return EXIT_FAILURE;
  }

  mpz_t x;
  mpz_init(x);
  mpz_clear(x);

  return EXIT_SUCCESS;
}
EOT

program=`tempfile` || { rm "$source"; exit 1; }
link_static=no
$cc -o "$program" -I"${prefix}/include" -L"${prefix}/lib" -Wl,-Bstatic "$source" -lgmp -Wl,-Bdynamic
if [ $? -eq 0 ]; then
    link_static=yes
    if [ $check = yes ]; then
	case $host in
	    *-cygwin)  ( PATH=${prefix}/bin:$PATH "$program" ) || { rm "$source" "$program"; exit 1; };;
	    *-mingw32) ( PATH=${prefix}/bin:$PATH "$program" ) || { rm "$source" "$program"; exit 1; };;
	    *)         "$program"                              || { rm "$source" "$program"; exit 1; };;
	esac
    fi
fi
link_shared=no
$cc -o "$program" -I"${prefix}/include" -L"${prefix}/lib" -Wl,-Bdynamic "$source" -lgmp -fpic -fPIC
if [ $? -eq 0 ]; then
    link_shared=yes
    if [ $check = yes ]; then
	case $host in
	    *-cygwin)  ( PATH=${prefix}/bin:$PATH "$program" )                       || { rm "$source" "$program"; exit 1; };;
	    *-mingw32) ( PATH=${prefix}/bin:$PATH "$program" )                       || { rm "$source" "$program"; exit 1; };;
	    *)         ( LD_LIBRARY_PATH=${prefix}/lib:$LD_LIBRARY_PATH "$program" ) || { rm "$source" "$program"; exit 1; };;
	esac
    fi
fi

if [ $link_static = yes -a $link_shared = yes ]; then
    /bin/echo -n 'both'
elif [ $link_static = yes ]; then
    /bin/echo -n 'static'
elif [ $link_shared = yes ]; then
    /bin/echo -n 'shared'
else
    /bin/echo -n 'no'
fi

rm "$source" "$program"
