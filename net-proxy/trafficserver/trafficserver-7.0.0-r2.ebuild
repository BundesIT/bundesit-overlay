# Copyright 1999-2013 Piratenpartei BundesIT
# Distributed under the terms of the GNU General Public License v2
#
# ebuild for the apache trafficserver
# clang useflag for exclusive clang build of the trafficservery

EAPI=5

GENTOO_DEPEND_ON_PERL="yes"
PYTHON_COMPAT=( python2_7 )
inherit autotools autotools-utils eutils user systemd perl-module python-single-r1

DESCRIPTION="Apache Traffic Server™ is fast, scalable and extensible caching proxy server"
HOMEPAGE="http://trafficserver.apache.org"
SRC_URI="mirror://apache/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="traffictop debug experimental-plugins wccp aio tinfo example-plugins test-tools geoip +perl +eventfd +caps +hwloc memcached imagemagick"

RDEPEND="
	dev-lang/tcl
	dev-libs/openssl
	dev-libs/libpcre
	traffictop? (
		sys-libs/ncurses[tinfo=]
		net-misc/curl
	)
	geoip? ( dev-libs/geoip )
	perl? ( 
		virtual/perl-Carp
		virtual/perl-IO
	)
	caps? ( sys-libs/libcap )
    hwloc? ( sys-apps/hwloc )
	wccp? ( >=sys-devel/flex-2.5.33 )
	memcached? ( dev-libs/libmemcached )
	imagemagick? ( media-gfx/imagemagick )
"

DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	dev-python/sphinx[$(python_gen_usedep 'python2*')]
	perl? ( virtual/perl-ExtUtils-MakeMaker )
"

group_user_check() {
    einfo "Checking for tc group ..."
    enewgroup tc
    einfo "Checking for tc user ..."
    enewuser tc -1 -1 /dev/null tc
}

check_32bit() {
	case "${ABI}" in
		arm|x86)
			echo "--enable-32bit-build"
			;;
		default) ;;
	esac
}

pkg_setup() {
    group_user_check || die "Failed to check/add needed user/group"
    use perl && perl_set_version
	python-single-r1_pkg_setup
}

src_prepare() {
    use traffictop && use tinfo && epatch "${FILESDIR}/00-ncurses.patch"

	# don't build the perl library within the tree
	epatch ${FILESDIR}/20-perl-build-external.patch

    eautoreconf
}

src_configure() {
    local myeconfargs=(
        --enable-layout=Gentoo
        --sysconfdir=/etc/${PN}
        --libexecdir=/usr/$(get_libdir)/${PN}
        --with-user=tc
        --with-group=tc
        --without-profiler
        $(use_enable eventfd)
		$(use_enable hwloc)
	    $(use_with traffictop ncurses)
		$(use_enable aio experimental-linux-native-aio)
		$(use_enable debug)
		$(use_enable example-plugins)
	    $(use_enable experimental-plugins)
		$(use_enable test-tools)
		$(use_enable wccp)
		$(use_enable eventfd)
		$(use_enable caps posix-cap)
		$(check_32bit)
	)
    autotools-utils_src_configure
}

src_compile() {
    autotools-utils_src_compile
	if use perl; then
	  perl_set_version
	  cd ${BUILD_DIR}/lib/perl || die
	  einfo "building perl module in " $(pwd)
	  make Makefile-pl
	  perl-module_src_configure
	  perl-module_src_compile
	  # remove packlist
	fi
}

src_test() {
    autotools-utils_src_test
}

src_install() {
    autotools-utils_src_install

    [ -z `ls -A ${D}/var/lib/`] && rmdir ${D}/var/lib

    keepdir /var/log/trafficserver
    fowners tc:tc /var/log/trafficserver

    keepdir /var/cache/trafficserver
    
    fowners tc:tc /etc/trafficserver

    keepdir /etc/trafficserver/snapshots
    fowners tc:tc /etc/trafficserver/snapshots

    newinitd ${FILESDIR}/tc.init trafficserver
    newconfd ${FILESDIR}/tc.confd trafficserver

    systemd_dounit ${BUILD_DIR}/rc/trafficserver.service
	systemd_newtmpfilesd "${FILESDIR}/trafficserver-tempdir.conf" "30-trafficserver.conf"

	if use perl; then
	  perl_set_version
	  cd ${BUILD_DIR}/lib/perl || die
	  myinst="DESTDIR=${D}"
	  perl-module_src_install

	  # cleanup
	  # perl_delete_packlist does only remove in vendorarchlib
	  einfo "removing \"${D}/${ARCH_LIB}\""
	  rm -rf ${D}/${ARCH_LIB}
	fi
}

pkg_postinst() {
    elog "Remeber to update your configuration file."
    elog "A full list of changes could be found on here:"
    elog "  https://cwiki.apache.org/confluence/display/TS/What's+New+in+v7.0.x"
}
