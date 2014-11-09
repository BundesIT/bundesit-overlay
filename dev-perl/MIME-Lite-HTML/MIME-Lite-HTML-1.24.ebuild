# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR="ALIAN"
inherit perl-module

DESCRIPTION="Provide routine to transform a HTML page in a MIME-Lite mail"

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/libwww-perl
	dev-perl/HTML-Parser
	dev-perl/MIME-Lite
	dev-perl/URI"
DEPEND="${RDEPEND}"

SRC_TEST="do"
