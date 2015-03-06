# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


EAPI=5

inherit eutils

DESCRIPTION="XenServer guest utilities"
HOMEPAGE="http://www.xenserver.org"
SRC_URI="amd64? ( http://gentoo.bundesit.de/distfiles/generic/xe-guest-utilities_6.2.0-1137_amd64.deb )
x86? ( http://gentoo.bundesit.de/distfiles/generic/xe-guest-utilities_6.2.0-1137_i386.deb )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-apps/iproute2"
RDEPEND="${DEPEND}"

src_unpack() {
  unpack "${A}"
  unpack ./data.tar.gz
}

S=${WORKDIR}
src_prepare() {
  epatch "${FILESDIR}/00-gentoo.patch"
}

src_configure() { :; }
src_compile()   { :; }

src_install() {
  insinto /etc/udev/rules.d/
  newins lib/udev/rules.d/z10_xen-vcpu-hotplug.rules 85_xen-vcpu-hotplug.rules || die
  newins "${FILESDIR}/85_xen-memory-hotplug.rules" 85_xen-memory-hotplug.rules || die
  into /usr/
  dobin usr/bin/xenstore || die
  dosym xenstore /usr/bin/xenstore-chmod || die
  dosym xenstore /usr/bin/xenstore-exists || die
  dosym xenstore /usr/bin/xenstore-list || die
  dosym xenstore /usr/bin/xenstore-ls || die
  dosym xenstore /usr/bin/xenstore-read || die
  dosym xenstore /usr/bin/xenstore-rm || die
  dosym xenstore /usr/bin/xenstore-watch || die
  dosym xenstore /usr/bin/xenstore-write || die


  dosbin usr/sbin/xe-daemon || die
  dosbin usr/sbin/xe-linux-distribution || die
  dosbin usr/sbin/xe-update-guest-attrs || die

  dodoc usr/share/doc/xe-guest-utilities/{COPYING.LGPL.gz,COPYING.gz,copyright} || die

  newinitd "${FILESDIR}/xe-daemon.init" xe-daemon
  newconfd "${FILESDIR}/xe-daemon.confd" xe-daemon
}
