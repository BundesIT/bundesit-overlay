# Copyright 1999-2013 Piratenpartei BundesIT
# Distributed under the terms of the GNU General Public License v2
#
# ebuild for the apache trafficserver
# clang useflag for exclusive clang build of the trafficservery

EAPI=5

inherit autotools autotools-utils eutils

DESCRIPTION="Apache Traffic Server™ is fast, scalable and extensible caching proxy server"
HOMEPAGE="http://trafficserver.apache.org"
SRC_URI="mirror://apache/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang experimental-plugins"

DEPEND="dev-lang/tcl
    clang? ( sys-devel/clang:0/3.3 )"
RDEPEND="dev-lang/tcl"

group_user_check() {
    einfo "Checking for tc group ..."
    enewgroup tc
    einfo "Checking for tc  group ..."
    enewuser tc -1 -1 /dev/null tc
}

pkg_setup() {
    group_user_check || die "Failed to check/add needed user/group"
}

src_prepare() {
	epatch ${FILESDIR}/00-runtimedir.patch
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
        --disable-libev
        --without-profiler
        --enable-eventfd
	$(use_enable experimental-plugins))
    autotools-utils_src_configure
}

src_install() {
    autotools-utils_src_install

    [ -z `ls -A ${D}/var/lib/`] && rmdir ${D}/var/lib

    touch ${D}/var/log/trafficserver/.keep
    touch ${D}/var/cache/trafficserver/.keep
    touch ${D}/run/trafficserver/.keep

    newinitd ${FILESDIR}/tc.init trafficserver
    newconfd ${FILESDIR}/tc.confd trafficserver
}
