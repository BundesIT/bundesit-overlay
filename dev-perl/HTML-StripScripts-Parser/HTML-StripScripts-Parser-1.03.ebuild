# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR="DRTECH"
inherit perl-module

DESCRIPTION="XSS filter using HTML::Parser"

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/HTML-Parser
	dev-perl/HTML-StripScripts"

DEPEND="${RDEPEND}"

SRC_TEST="do"
