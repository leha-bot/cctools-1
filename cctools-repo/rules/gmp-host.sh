build_gmp_host() {
    PKG=gmp
    PKG_VERSION=$gmp_version
    PKG_SUBVERSION=
    PKG_URL="https://gmplib.org/download/gmp/${PKG}-${PKG_VERSION}.tar.xz"
    PKG_DESC="The GNU Multiple Precision Arithmetic Library"
    PKG_DEPS=""
    O_FILE=$SRC_PREFIX/${PKG}/${PKG}-${PKG_VERSION}.tar.xz
    S_DIR=$src_dir/${PKG}-${PKG_VERSION}
    B_DIR=$build_dir/${PKG}-host

    c_tag ${PKG}-host && return

    pushd .

    banner "Build $PKG"

    download $PKG_URL $O_FILE

    unpack $src_dir $O_FILE

    patchsrc $S_DIR $PKG $PKG_VERSION

    mkdir -p $B_DIR
    cd $B_DIR

    # Configure here

    ${S_DIR}/configure	\
	--prefix=${TARGET_DIR}-host \
	--enable-cxx \
	--disable-werror \
	--enable-static \
	--disable-shared || error "Configure $PKG."

    $MAKE $MAKEARGS || error "make $MAKEARGS"

    $MAKE install || error "make install"

    popd
    s_tag ${PKG}-host
}
