#!/usr/bin/env sh

version=$1
build=$2
host=$3
abi=$4
prefix=$5
link=$6
check=$7

cc=`"${0%/*}/../cc.sh" $build $host "$abi"` || exit 1

x=`/bin/echo -e -n '#include <mpfr.h>\nMPFR_VERSION_MAJOR\nMPFR_VERSION_MINOR\nMPFR_VERSION_PATCHLEVEL' \
    | { $cc -E -I"${prefix}/include" -x c - || exit 1; } \
    | { tail --lines=3 || exit 1; } \
    | { tr '\n' '.' || exit 1; } \
    | { grep -Eo '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' || exit 1; } \
    | { tr --delete '\n' || exit 1; }`
y=`/bin/echo -e -n "$version\n$x" | { sort --version-sort || exit 1; } | { tail --lines=1 || exit 1; }`
[ $y != $x ] && { /bin/echo -n 'no'; exit 0; }

source=`tempfile --suffix .c` || exit 1
cat >"$source" <<EOT
#include <mpfr.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  int i = -1, j = -1, k = -1;
  sscanf("$version", "%d%*c%d%*c%d", &i, &j, &k);
  if (MPFR_VERSION_MAJOR < i) {
    return EXIT_FAILURE;
  }
  if (MPFR_VERSION_MAJOR == i) {
    if (MPFR_VERSION_MINOR < j) {
      return EXIT_FAILURE;
    }
    if (MPFR_VERSION_MINOR == j) {
      if (MPFR_VERSION_PATCHLEVEL < k) {
        return EXIT_FAILURE;
      }
    }
  }

  i = -1; j = -1; k = -1;
  sscanf(mpfr_get_version(), "%d%*c%d%*c%d", &i, &j, &k);
  if (i != MPFR_VERSION_MAJOR
        || j != MPFR_VERSION_MINOR
        || k != MPFR_VERSION_PATCHLEVEL)
  {
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
EOT

program=`tempfile` || { rm "$source"; exit 1; }
if [ $link = static -o $link = both ]; then
    $cc -o "$program" -I"${prefix}/include" -L"${prefix}/lib" -Wl,-Bstatic "$source" -lmpfr -Wl,-Bdynamic \
	|| { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; }
    if [ $check = yes ]; then
	case $host in
	    *-cygwin)  ( PATH=${prefix}/bin:$PATH "$program" ) || { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; };;
	    *-mingw32) ( PATH=${prefix}/bin:$PATH "$program" ) || { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; };;
	    *)         "$program"                              || { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; };;
	esac
    fi
fi
if [ $link = shared -o $link = both ]; then
    $cc -o "$program" -I"${prefix}/include" -L"${prefix}/lib" -Wl,-Bdynamic "$source" -lmpfr -fpic -fPIC \
	|| { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; }
    if [ $check = yes ]; then
	case $host in
	    *-cygwin)  ( PATH=${prefix}/bin:$PATH "$program" )                       \
		           || { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; };;
	    *-mingw32) ( PATH=${prefix}/bin:$PATH "$program" )                       \
		           || { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; };;
	    *)         ( LD_LIBRARY_PATH=${prefix}/lib:$LD_LIBRARY_PATH "$program" ) \
                           || { rm "$source" "$program"; /bin/echo -n 'no'; exit 0; };;
	esac
    fi
fi

/bin/echo -n 'yes'
rm "$source" "$program"
exit 0
