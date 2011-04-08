#!/usr/bin/env sh

build=$1
host=$2
abi=$3

if [ $build = $host ]; then
    gcc=gcc
else
    gcc=${host}-gcc
fi

x86 () {
    case "$1" in
	unspecified) /bin/echo -n "$2"; exit 0;;
	32)          /bin/echo -n "$2 -m32"; exit 0;;
	*)           exit 1;;
    esac
}

x86_64 () {
    case "$1" in
	unspecified) /bin/echo -n "$2"; exit 0;;
	32)          /bin/echo -n "$2 -m32"; exit 0;;
	64)          /bin/echo -n "$2 -m64"; exit 0;;
	*)           exit 1;;
    esac
}

powerpc () {
    case "$1" in
	unspecified) /bin/echo -n "$2"; exit 0;;
	*)           exit 1;;
    esac
}

powerpc64 () {
    case "$1" in
	unspecified) /bin/echo -n "$2"; exit 0;;
	*)           exit 1;;
    esac
}

sparc () {
    case "$1" in
	unspecified) /bin/echo -n "$2"; exit 0;;
	*)           exit 1;;
    esac
}

sparcv9 () {
    case "$1" in
        unspecified) /bin/echo -n "$2"; exit 0;;
	*)           exit 1;;
    esac
}

others () {
    case "$1" in
	unspecified) /bin/echo -n "$2"; exit 0;;
	*)           exit 1;;
    esac
}

case $host in
    # X86 and X86-64.
    x86-*)        x86 "$abi" $gcc;;
    x86_64-*)     x86_64 "$abi" $gcc;;
    i386-*)       x86 "$abi" $gcc;;
    i486-*)       x86 "$abi" $gcc;;
    i586-*)       x86 "$abi" $gcc;;
    pentium-*)    x86 "$abi" $gcc;;
    i686-*)       x86 "$abi" $gcc;;
    pentiumpro-*) x86 "$abi" $gcc;;
    pentium2-*)   x86 "$abi" $gcc;;
    pentium3-*)   x86 "$abi" $gcc;;
    pentiumm-*)   x86 "$abi" $gcc;;
    pentium4-*)   x86_64 "$abi" $gcc;;
    core2-*)      x86_64 "$abi" $gcc;;
    corei-*)      x86_64 "$abi" $gcc;;
    atom-*)       x86_64 "$abi" $gcc;;
    k6-*)         x86 "$abi" $gcc;;
    k62-*)        x86 "$abi" $gcc;;
    k63-*)        x86 "$abi" $gcc;;
    athlon-*)     x86 "$abi" $gcc;;
    athlon_*-*)   x86 "$abi" $gcc;;
    opteron-*)    x86_64 "$abi" $gcc;;
    athlon64-*)   x86_64 "$abi" $gcc;;
    geode-*)      x86 "$abi" $gcc;;
    c3*-*)        x86 "$abi" $gcc;;

    # IA-64 under HP-UX.
    ia64*-*-hpux*)
	case "$abi" in
	    unspecified) /bin/echo -n "$gcc"; exit 0;;
	    32)          /bin/echo -n "$gcc -milp32"; exit 0;;
	    64)          /bin/echo -n '$gcc -mlp64'; exit 0;;
	    *)           exit 1;;
	esac;;
    itanium*-*-hpux*)
	case "$abi" in
	    unspecified) /bin/echo -n "$gcc"; exit 0;;
	    32)          /bin/echo -n "$gcc -milp32"; exit 0;;
	    64)          /bin/echo -n "$gcc -mlp64"; exit 0;;
	    *)           exit 1;;
	esac;;

    # IA-64 under other OS.
    ia64*)
	case "$abi" in
	    unspecified) /bin/echo -n "$gcc"; exit 0;;
	    32)          exit 1;;
	    64)          /bin/echo -n "$gcc -mlp64"; exit 0;;
	    *)           exit 1;;
	esac;;
    itanium*)
	case "$abi" in
	    unspecified) /bin/echo -n "$gcc"; exit 0;;
	    32)          exit 1;;
	    64)          /bin/echo -n "$gcc -mlp64"; exit 0;;
	    *)           exit 1;;
	esac;;

    # MIPS under IRIX 6.
    mips*-*-irix[6789])
	case "$abi" in
	    unspecified)  /bin/echo -n "$gcc"; exit 0;;
            o32)          /bin/echo -n "$gcc -mabi=32"; exit 0;;
	    n32)          /bin/echo -n "$gcc -mabi=n32"; exit 0;;
	    64)           /bin/echo -n "$gcc -mabi=64"; exit 0;;
	    *)            exit 1;;
	esac;;

    # MIPS under other OS.
    mips*)
	case "$abi" in
	    unspecified)  /bin/echo -n "$gcc"; exit 0;;
	    o32)          /bin/echo -n "$gcc -mabi=32"; exit 0;;
	    *)            exit 1;;
	esac;;

    # PowerPC and PowerPC 64.
    power-*)       powerpc "$abi" $gcc;;
    powerpc-*)     powerpc "$abi" $gcc;;
    powerpc64-*)   powerpc64 "$abi" $gcc;;
    powerpc401-*)  powerpc "$abi" $gcc;;
    powerpc403-*)  powerpc "$abi" $gcc;;
    powerpc405-*)  powerpc "$abi" $gcc;;
    powerpc505-*)  powerpc "$abi" $gcc;;
    powerpc601-*)  powerpc "$abi" $gcc;;
    powerpc602-*)  powerpc "$abi" $gcc;;
    powerpc603-*)  powerpc "$abi" $gcc;;
    powerpc603e-*) powerpc "$abi" $gcc;;
    powerpc604-*)  powerpc "$abi" $gcc;;
    powerpc604e-*) powerpc "$abi" $gcc;;
    powerpc620-*)  powerpc64 "$abi" $gcc;;
    powerpc630-*)  powerpc64 "$abi" $gcc;;
    powerpc740-*)  powerpc "$abi" $gcc;;
    powerpc7400-*) powerpc "$abi" $gcc;;
    powerpc7450-*) powerpc "$abi" $gcc;;
    powerpc750-*)  powerpc "$abi" $gcc;;
    powerpc801-*)  powerpc "$abi" $gcc;;
    powerpc821-*)  powerpc "$abi" $gcc;;
    powerpc823-*)  powerpc "$abi" $gcc;;
    powerpc860-*)  powerpc "$abi" $gcc;;
    powerpc970-*)  powerpc64 "$abi" $gcc;;
    powerpc8540-*) powerpc "$abi" $gcc;;
    power2-*)      powerpc "$abi" $gcc;;
    power3-*)      powerpc "$abi" $gcc;;
    power4-*)      powerpc64 "$abi" $gcc;;
    power5-*)      powerpc64 "$abi" $gcc;;
    power6-*)      powerpc64 "$abi" $gcc;;
    power7-*)      powerpc64 "$abi" $gcc;;
    power8-*)      powerpc64 "$abi" $gcc;;
    power9-*)      powerpc64 "$abi" $gcc;;

    # Sparc and Sparc V9.
    sparc-*)       sparc "$abi" $gcc;;
    sparc64-*)     sparc "$abi" $gcc;;
    sparcv8-*)     sparc "$abi" $gcc;;
    supersparc-*)  sparc "$abi" $gcc;;
    sparclite-*)   sparc "$abi" $gcc;;
    sparclet-*)    sparc "$abi" $gcc;;
    sparcv9-*)     sparcv9 "$abi" $gcc;;
    ultrasparc-*)  sparcv9 "$abi" $gcc;;
    ultrasparc2-*) sparcv9 "$abi" $gcc;;
    ultrasparc3-*) sparcv9 "$abi" $gcc;;

    *) others "$abi" $gcc;;
esac

exit 1
