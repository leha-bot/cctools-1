build_mpfr() {
    PKG=mpfr
    PKG_VERSION=$mpfr_version
    PKG_SUBVERSION=
    PKG_URL="http://www.mpfr.org/mpfr-${PKG_VERSION}/${PKG}-${PKG_VERSION}.tar.xz"
    PKG_DESC="C library for multiple-precision floating-point computations with correct rounding"
    PKG_DEPS=""
    O_FILE=$SRC_PREFIX/${PKG}/${PKG}-${PKG_VERSION}.tar.xz
    S_DIR=$src_dir/${PKG}-${PKG_VERSION}
    B_DIR=$build_dir/${PKG}

    c_tag $PKG && return

    pushd .

    banner "Build $PKG"

    if [ ! -f $O_FILE ]; then
	download $PKG_URL $O_FILE
    fi

    unpack $src_dir $O_FILE
    patchsrc $S_DIR $PKG $PKG_VERSION

    if [ "$USE_NATIVE_BUILD" = "yes" ]; then
	fix_bionic_shell $S_DIR
    fi

    mkdir -p $B_DIR
    cd $B_DIR

    # Configure here

    ${S_DIR}/configure	\
	--target=$TARGET_ARCH \
	--host=$TARGET_ARCH \
	--prefix=$TMPINST_DIR \
	--with-gmp=$TMPINST_DIR \
	--disable-werror \
	--disable-static \
	--enable-shared || error "Configure $PKG."

    $MAKE $MAKEARGS || error "make $MAKEARGS"

    $MAKE install || error "make install"

    $MAKE install prefix=${TMPINST_DIR}/${PKG}/cctools || error "package install"

    make_packages

    popd
    s_tag $PKG
}
