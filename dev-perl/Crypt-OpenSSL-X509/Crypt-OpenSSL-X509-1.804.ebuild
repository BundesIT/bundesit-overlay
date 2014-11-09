# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR="DANIEL"
inherit perl-module

DESCRIPTION="Perl extension to OpenSSL's X509 API."

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}"

SRC_TEST="do"
