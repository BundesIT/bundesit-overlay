# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Workaround ebuild for gentoo bug #484754"
HOMEPAGE="https://bugs.gentoo.org/show_bug.cgi?id=484754"
SRC_URI=""

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${FILESDIR}

src_install() {
	insinto "/etc/pam.d/"
	doins runuser
	doins runuser-l
	fowners root:root "/etc/pam.d/runuser" "/etc/pam.d/runuser-l"
	fperms  0664 "/etc/pam.d/runuser" "/etc/pam.d/runuser-l"
}
