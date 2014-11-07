# Copyright 1999-2013 Piratenpartei BundesIT
# Distributed under the terms of the GNU General Public License v2
#
# ebuild for the apache trafficserver
# clang useflag for exclusive clang build of the trafficservery

EAPI=5

inherit autotools autotools-utils eutils user

DESCRIPTION="Apache Traffic Server™ is fast, scalable and extensible caching proxy server"
HOMEPAGE="http://trafficserver.apache.org"
SRC_URI="mirror://apache/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="traffictop clang experimental-plugins wccp interim-cache spdy cppapi aio tinfo example-plugins test-tools +luajit +man geoip +collapsed-connection-plugin"

RDEPEND="dev-lang/tcl 
	traffictop? ( sys-libs/ncurses[tinfo=] )
	spdy? ( net-misc/spdylay )
	geoip? ( dev-libs/geoip )"

DEPEND="${RDEPEND}
    clang? ( >=sys-devel/clang-3.3 )
	man? ( dev-python/sphinx )"

group_user_check() {
    einfo "Checking for tc group ..."
    enewgroup tc
    einfo "Checking for tc user ..."
    enewuser tc -1 -1 /dev/null tc
}

pkg_setup() {
    group_user_check || die "Failed to check/add needed user/group"
}

src_prepare() {
    use traffictop && use tinfo && epatch "${FILESDIR}/00-ncurses.patch"
	use cppapi && epatch ${FILESDIR}/20-atscppapi-include-fix.patch
	use man && epatch ${FILESDIR}/20-man.patch
    eautoreconf
}

src_configure() {
    if use clang ; then
        CC=clang
        CXX=clang++
        tc-export CC CXX
    fi
    
    local myeconfargs=(
        --enable-layout=Gentoo
        --sysconfdir=/etc/${PN}
        --libexecdir=/usr/$(get_libdir)/${PN}
        --with-user=tc
        --with-group=tc
        --without-profiler
        --enable-eventfd
    	--disable-hwloc
    $(use_with traffictop ncurses)
    $(use_enable experimental-plugins)
	$(use_enable spdy)
	$(use_enable cppapi)
	$(use_enable aio linux-native-aio)
	$(use_enable example-plugins)
	$(use_enable test-tools)
	$(use_enable luajit)
	$(use_enable man man-pages)
	$(use_enable geoip maxmind-geoip)
	$(use_enable collapsed-connection-plugin))
    autotools-utils_src_configure
}

src_test() {
    autotools-utils_src_test
}

src_install() {
    autotools-utils_src_install

    [ -z `ls -A ${D}/var/lib/`] && rmdir ${D}/var/lib

	# install manpages in the right location
	rm doc/man/man_page_template.txt
	doman doc/man/*
	rm -rf ${D}/usr/share/doc/trafficserver/trafficshell

    keepdir /var/log/trafficserver
    fowners tc:tc /var/log/trafficserver

    keepdir /var/cache/trafficserver
    
    keepdir /run/trafficserver
    fowners tc:tc /run/trafficserver

    fowners tc:tc /etc/trafficserver

    keepdir /etc/trafficserver/snapshots
    fowners tc:tc /etc/trafficserver/snapshots

    newinitd ${FILESDIR}/tc.init trafficserver
    newconfd ${FILESDIR}/tc.confd trafficserver
}

pkg_postinst() {
    elog "Remeber to update your configuration file."
    elog "A full list of changes could be found on here:"
    elog "  https://cwiki.apache.org/confluence/display/TS/What%27s+new+in+v5.0.x"
}
