# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR="CHROMATIC"
inherit perl-module

DESCRIPTION="Perl module implementing CipherSaber encryption."

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}"

SRC_TEST="do"
