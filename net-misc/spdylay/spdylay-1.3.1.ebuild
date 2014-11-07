# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils linux-info

DESCRIPTION="The experimental SPDY protocol version 2, 3 and 3.1 implementation in C"
HOMEPAGE="http://tatsuhiro-t.github.io/spdylay"
SRC_URI="https://github.com/tatsuhiro-t/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test examples shrpx tools spdyd +man"

REQUIRED_USE="shrpx? ( tools )
	spdyd? ( tools )"

DEPEND=">=dev-util/pkgconfig-0.20
	>=sys-libs/zlib-1.2.3
	test? ( >=dev-util/cunit-1.2 )
	examples? ( >=dev-libs/openssl-1.0.1 )
	>=dev-libs/libxml2-2.7.7
	shrpx? ( >=dev-libs/libevent-2.0.8[ssl] )
	man? ( dev-python/sphinx )"

RDEPEND="${DEPEND}"

pkg_setup() {
	if use spdyd ; then
		CONFIG_CHECK="EPOLL"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	if use shrpx ; then epatch ${FILESDIR}/00-with-shrpx.patch ; else epatch ${FILESDIR}/00-no-shrpx.patch ; fi
	if use test ; then epatch ${FILESDIR}/10-with-tests.patch ; else epatch ${FILESDIR}/10-no-tests.patch ; fi
	use spdyd || epatch ${FILESDIR}/20-no-spdyd.patch
	
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable examples) \
		$(use_with examples libxml2) \
		$(use_enable tools src)
}

src_compile() {
	emake || die "emake failed"
	cd doc && emake man || die "emake man failed"
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf ${D}/usr/share/doc/spdylay
	
	if ! use tools || ! use examples ; then
		rm -rf ${D}/usr/bin
	fi

	if use man ; then
		doman doc/manual/man/*
	fi

	dodoc README.rst ChangeLog NEWS shrpx.conf.sample proxy.pac.sample AUTHORS
}
