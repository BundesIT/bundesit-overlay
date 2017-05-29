# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils rpm linux-info

DESCRIPTION="Brother printer driver for DCP-9055CDN"

HOMEPAGE="http://support.brother.com"

SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/dcp9055cdnlpr-1.1.1-5.i386.rpm
	http://www.brother.com/pub/bsc/linux/dlf/dcp9055cdncupswrapper-1.1.1-5.i386.rpm"

LICENSE="brother-eula GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"

RESTRICT="mirror strip"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S=${WORKDIR}

pkg_setup() {
	CONFIG_CHECK=""
	if use amd64; then
		CONFIG_CHECK="${CONFIG_CHECK} ~IA32_EMULATION"
	fi

	linux-info_pkg_setup
}

src_unpack() {
	rpm_unpack ${A}
}

src_prepare() {
	# adapted from the archlinux package
	# https://aur.archlinux.org/packages/brother-brgenml1/
	#epatch "${FILESDIR}/brother_lpdwrapper_BrGenML1.patch"
	return
}


src_install() {
	dodir "/usr"
	insinto "/usr"
	doins -r "usr/bin"
	doins -r "usr/local"

	dodir "/usr/local/Brother/Printer/dcp9055cdn/cupswrapper"

	fperms 755 /usr/local/Brother/Printer/dcp9055cdn/{lpd,inf,cupswrapper} /usr/local/Brother/{Printer,} 
	fperms 755 /usr/local/Brother/Printer/dcp9055cdn/lpd/filterdcp9055cdn /usr/local/Brother/Printer/dcp9055cdn/lpd/brdcp9055cdnfilter /usr/local/Brother/Printer/dcp9055cdn/lpd/psconvertij2

	dodir "/var/spool/lpd"
	keepdir "/var/spool/lpd"

	dodir "/usr/$(get_libdir)/cups/filter"
	insinto "/usr/$(get_libdir)/cups/filter"

	doins ${FILESDIR}/brlpdwrapperdcp9055cdn
	fperms 755 "/usr/$(get_libdir)/cups/filter/brlpdwrapperdcp9055cdn"

	dodir "/usr/libexec/cups/filter/"
	dosym "/usr/$(get_libdir)/cups/filter/brlpdwrapperdcp9055cdn" "/usr/libexec/cups/filter/brlpdwrapperdcp9055cdn"

	dodir "/usr/share/cups/model"
	insinto "/usr/share/cups/model"
	doins "usr/local/Brother/Printer/dcp9055cdn/cupswrapper/dcp9055cdn.ppd"
}

pkg_postinst() {
	einfo "Brother DCP-9055CDN printer installed"
}
