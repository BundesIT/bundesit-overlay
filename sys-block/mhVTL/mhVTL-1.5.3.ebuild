# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils linux-mod user udev


MY_PV="$(replace_version_separator 2 '-')_release"
MY_P="${PN,,}-${MY_PV}"

DESCRIPTION="Linux based Virtual Tape Library"
HOMEPAGE="http://sites.google.com/site/linuxvtl2/"
SRC_URI="https://github.com/markh794/mhvtl/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="sys-fs/lsscsi
        sys-libs/zlib
		dev-libs/lzo
		sys-apps/sg3_utils
		"


RDEPEND="sys-auth/runuser-pam" # bug #484754


S="${WORKDIR}/${MY_P}"
MODULE_NAMES="mhvtl(misc:${S}/kernel:${S}/kernel)"

MHVTL_HOME_PATH=/var/spool/media/vtl
LUSER='vtl'
LGROUP='vtl'

pkg_setup() {
    linux-mod_pkg_setup

	CONFIG_CHECK="~BLK_DEV_SR ~CHR_DEV_SG"
	check_extra_config
	BUILD_PARAMS="KDIR=${KV_DIR}"
	linux-mod_pkg_setup

	enewgroup ${LGROUP}
	enewuser ${LUSER} -1 -1 ${MHVTL_HOME_PATH} "${LGROUP},tape"
}

src_prepare() {
	epatch "${FILESDIR}/001_makefile-1.5.3.patch"
	epatch "${FILESDIR}/002_make_vtl_media-1.5.3.patch"
}

src_compile() {
	emake clean
	linux-mod_src_compile
	emake -j1 USR=${LUSER} GROUP=${LGROUP} MHVTL_HOME_PATH=${MHVTL_HOME_PATH}
}

src_install() {
	emake USR=${LUSER} GROUP=${LGROUP} MHVTL_HOME_PATH=${MHVTL_HOME_PATH} DESTDIR="${D}" install

	local udevdir="$(get_udevdir)"
    insinto ${udevdir}/rules.d
	doins "${FILESDIR}/70-mhvtl.rules" 
	
	sed -i "s/%LUSER%/${LUSER}/g;s/%LGROUP%/${LGROUP}/g" "${udevdir}/rules.d/70-mhvtl.rules"

	rm ${D}/etc/init.d/mhvtl
	newinitd "${FILESDIR}"/mhvtl.init.d mhvtl || die

	if use doc; then
		dohtml -r doc/*
	fi

	doman man/*.1
	dodoc README INSTALL

	linux-mod_src_install
	keepdir /opt/mhvtl
}
