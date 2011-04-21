#!/usr/bin/env sh

version=$1
[ ! -n "$version" ] && exit 1
prefix=$2
[ ! -n "$prefix" ] && exit 1
link=$3
[ ! -n "$link" ] && exit 1
check=$4
[ ! -n "$check" ] && exit 1

version=`echo -n "$version.0.0" \
    | { grep -Eo '^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
echo -e -n '#include <gmp.h>\n__GNU_MP_VERSION __GNU_MP_VERSION_MINOR __GNU_MP_VERSION_PATCHLEVEL' \
    | { "$CC" -E -I"$prefix/include" -x c - || exit 1; } \
    | { tail --lines=1 || exit 1; } \
    | { tr '\n' '.' || exit 1; } \
    | { grep -Eo "^$version\$" || exit 1; }

source=`tempfile --suffix .c` || exit 1
cat >"$source" <<EOT
#include <gmp.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  int i = -1, j = -1, k = -1;
  if (sscanf("$version.0.0", "%d%*c%d%*c%d", &i, &j, &k) != 3) {
    return EXIT_FAILURE;
  }
  if (__GNU_MP_VERSION != i) {
    return EXIT_FAILURE;
  }
  if (__GNU_MP_VERSION_MINOR != j) {
    return EXIT_FAILURE;
  }
  if (__GNU_MP_VERSION_PATCHLEVEL != k) {
    return EXIT_FAILURE;
  }

  i = -1; j = -1; k = -1;
  char c = 0, d = 0;
  int result = sscanf(gmp_version, "%d%c%d%c%d", &i, &c, &j, &d, &k);
  if (c != '.') {
    if (result != 1) {
      return EXIT_FAILURE;
    }
    j = 0; k = 0;
  }
  else if (d != '.') {
    if (result != 3) {
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

if [ $link = static -o $link = both ]; then
    "$CC" -o "$program" -I"$prefix/include" -L"$prefix/lib" -Wl,-Bstatic "$source" -lgmp -Wl,-Bdynamic || exit 1
    [ $check = yes ] && { "$program" || { rm "$source" "$program"; exit 1; }; }
fi

if [ $link = shared -o $link = both ]; then
    "$CC" -o "$program" -I"$prefix/include" -L"$prefix/lib" -Wl,-Bdynamic "$source" -lgmp -fpic -fPIC || exit 1
    [ $check = yes ] && { "$program" || { rm "$source" "$program"; exit 1; }; }
fi

rm "$source" "$program"
