# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mtail/mtail-1.1.1.ebuild,v 1.6 2005/01/01 15:15:35 eradicator Exp $

EAPI=5

inherit eutils

DESCRIPTION="a tool for managing events and logs."
HOMEPAGE="http://logstash.net/"
SRC_URI="https://download.elasticsearch.org/${PN}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/jre dev-python/pyes"


src_prepare() {
  epatch "${FILESDIR}/00-symlink-fix.patch"
}
src_configure() { :; }
src_compile()   { :; }

src_install() {
	# install our example config
	insinto /etc/${PN}/conf.d
	doins "${FILESDIR}/agent.conf.sample"
	
	# create our logging directory
	keepdir "/var/log/${PN}"
	
	# copy tool
	dodir "/opt"
    cp -R "${S}/" "${D}/opt/${PN}" || die

	# move the patterns to /etc
	mv "${D}/opt/${PN}/patterns" "${D}/etc/${PN}/patterns"
	dosym "/etc/${PN}/patterns" "/opt/${PN}/patterns"

	# cleanup the doc and example directories
	find ${D}/opt/${PN}/ -type d \( -name doc -or -name examples \) -exec rm -rf '{}' \;

	# create a symlink to the logstash startscript
	dodir "/usr/bin"
	dosym "/opt/${PN}/bin/logstash" "/usr/bin/logstash"
    
	# requires pyes
	# https://logstash.jira.com/browse/LOGSTASH-211
	into /usr/
	dobin ${FILESDIR}/logstash_index_cleaner.py
	
	# install logrotate file
	dodir /etc/logrotate.d
	cp ${FILESDIR}/logstash.logrotate ${D}/etc/logrotate.d/${PN} || die \
	 "failed copying lograte file into place"

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
}
