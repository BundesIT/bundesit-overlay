# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user systemd

DESCRIPTION="A plugin-driven server agent for collecting & reporting metrics"
HOMEPAGE="http://influxdb.com"
SRC_URI="https://dl.influxdata.com/telegraf/releases/${P}_linux_amd64.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
pkg_setup() {
  enewgroup telegraf
  enewuser telegraf -1 -1 -1 telegraf
}

src_configure() { :;  }
src_compile() { :;  }

src_install() {
  # install binary
  dobin ${S}/usr/bin/telegraf

  # install config directory
  insinto /etc
  doins -r ${S}/etc/telegraf
  keepdir /etc/telegraf/telegraf.d

  # create the logging directory
  diropts -o telegraf
  dodir /var/log/telegraf
  keepdir /var/log/telegraf

  # install the systemd unit file
  systemd_dounit ${S}/usr/lib/telegraf/scripts/telegraf.service

  # install our own openrc service
  newinitd ${FILESDIR}/telegraf.init telegraf
}

