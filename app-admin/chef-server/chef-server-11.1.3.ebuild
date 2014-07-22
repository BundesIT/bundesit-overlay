# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="The full stack of chef-server."
HOMEPAGE="https://getchef.com"
SRC_URI="https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.1.3-1_amd64.deb"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
  unpack "${A}"
  unpack ./data.tar.gz
}

S=${WORKDIR}

src_prepare() {
  epatch ${FILESDIR}/00-gentoo-symlinks.patch || die
}

src_configure() { :; }
src_compile()   { :; }

src_install() {
  cp -R ${S}/opt ${D}/opt
  dosym /opt/chef-server/bin/chef-server-ctl /usr/bin/chef-server-ctl
}

pkg_postinst() {
  if [ -e /etc/chef-server/chef-server-running.json ]; then
    elog "You have upgraded Chef Server!"
    elog "The next step in the upgrade process is to run:"
    elog "sudo chef-server-ctl upgrade"
  else
    echo "Thank you for installing Chef Server!"
	echo "The next step in the install process is to run:"
    echo "sudo chef-server-ctl reconfigure"
  fi
}
