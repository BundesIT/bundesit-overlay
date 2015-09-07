# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# XtraBackup has fucked up include paths, and wont work out of source
CMAKE_IN_SOURCE_BUILD=1

inherit eutils cmake-utils

DESCRIPTION="Percona XtraBackup is an open source, free MySQL hot backup software that performs non-blocking backups for InnoDB and XtraDB databases."
HOMEPAGE="http://www.percona.com/software/percona-xtrabackup"
SRC_URI="http://www.percona.com/redir/downloads/XtraBackup/LATEST/source/tarball/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND="sys-libs/zlib
	dev-libs/libaio
	virtual/mysql
	sys-libs/ncurses
	dev-libs/libgcrypt"
DEPEND="${REPEND}
	sys-devel/flex
	sys-devel/bison
	dev-util/cmake"

src_configure() {
	local mycmakeargs=(
		-DBUILD_CONFIG=xtrabackup_release
	)

	cmake-utils_src_configure
}
