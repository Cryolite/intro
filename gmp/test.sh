#!/usr/bin/env sh

version=$1
host=$2
prefix=$3
link=$4
check=$5

x=`/bin/echo -e '#include <gmp.h>\n__GNU_MP_VERSION\n__GNU_MP_VERSION_MINOR\n__GNU_MP_VERSION_PATCHLEVEL' \
     | gcc -E -I"${prefix}/include" -x c - | tail --lines=3 | tr '\n' '.' \
     | grep -Eo '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | tr --delete '\n'`
y=`/bin/echo -e -n "$version\n$x" | sort --version-sort | tail --lines=1`
if [ $y != $x ]; then
  exit 0
fi

source=`tempfile --suffix .c`
cat >"$source" <<EOT
#include <gmp.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  int i = -1, j = -1, k = -1;
  sscanf("$version", "%d%*c%d%*c%d", &i, &j, &k);
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
  sscanf(gmp_version, "%d%*c%d%*c%d", &i, &j, &k);
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

program=`tempfile` || (rm "$source"; exit 0)
if [ $link = static -o $link = both ]; then
    gcc -o "$program" -I"${prefix}/include" -L"${prefix}/lib" -Wl,-Bstatic "$source" -lgmp -Wl,-Bdynamic || (rm "$source"; exit 0)
    if [ $check = yes ]; then
	case $host in
	    *-cygwin)  (PATH=${prefix}/bin:$PATH "$program") || (rm "$source" "$program"; exit 0);;
	    *-mingw32) (PATH=${prefix}/bin:$PATH "$program") || (rm "$source" "$program"; exit 0);;
	    *)         "$program"                            || (rm "$source" "$program"; exit 0);;
	esac
    fi
fi
if [ $link = shared -o $link = both ]; then
    gcc -o "$program" -I"${prefix}/include" -L"${prefix}/lib" -Wl,-Bdynamic "$source" -lgmp -fpic -fPIC || (rm "$source"; exit 0)
    if [ $check = yes ]; then
	case $host in
	    *-cygwin)  (PATH=${prefix}/bin:$PATH "$program")                       || (rm "$source" "$program"; exit 0);;
	    *-mingw32) (PATH=${prefix}/bin:$PATH "$program")                       || (rm "$source" "$program"; exit 0);;
	    *)         (LD_LIBRARY_PATH=${prefix}/lib:$LD_LIBRARY_PATH "$program") || (rm "$source" "$program"; exit 0);;
	esac
    fi
fi

/bin/echo -n 'passed'
rm "$source" "$program"
