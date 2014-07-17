# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/chef/chef-10.24.0.ebuild,v 1.1 2013/03/01 19:17:14 hollow Exp $

EAPI=4
USE_RUBY="ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"


inherit ruby-fakegem user

DESCRIPTION="Chef is a systems integration framework"
HOMEPAGE="http://wiki.opscode.com/display/chef"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# specs have various indempotency issues which result in the global Chef::Config
# object to be replaced and subsequently fails other specs. Revisit this later.
RESTRICT="test"

ruby_add_rdepend "
	<app-admin/chef-zero-2.1
	>=app-admin/chef-zero-2.0.2

	>=dev-ruby/diff-lcs-1.2.4
	<dev-ruby/diff-lcs-1.3
	
	>=dev-ruby/erubis-2.7
	<dev-ruby/erubis-2.8
	
	>=dev-ruby/highline-1.6.9
	<dev-ruby/highline-1.7

	<=dev-ruby/json-1.8.1
	>=dev-ruby/json-1.4.4
	
	>=dev-ruby/mime-types-1.16

	>=dev-ruby/mixlib-authentication-1.3
	>=dev-ruby/mixlib-cli-1.4
	>=dev-ruby/mixlib-config-2.0
	>=dev-ruby/mixlib-log-1.3
	>=dev-ruby/mixlib-shellout-1.4
	
	dev-ruby/net-ssh:2.6
	>=dev-ruby/net-ssh-multi-1.1

	>=dev-ruby/ohai-7.0.4
	
	>=dev-ruby/pry-0.9
	
	<dev-ruby/rest-client-1.7.0
	>=dev-ruby/rest-client-1.0.4

	>=dev-ruby/yajl-ruby-1.1
	"

all_ruby_install() {
	all_fakegem_install

	keepdir /etc/chef /var/lib/chef /var/log/chef

	doinitd "${FILESDIR}/initd/chef-client"
	doconfd "${FILESDIR}/confd/chef-client"

	insinto /etc/chef
	doins "${FILESDIR}/client.rb"
	doins "${FILESDIR}/solo.rb"

	doman distro/common/man/man1/*.1
	doman distro/common/man/man8/*.8
}

pkg_setup() {
	enewgroup chef
	enewuser chef -1 -1 /var/lib/chef chef
}

pkg_postinst() {
	elog
	elog "You should edit /etc/chef/client.rb before starting the service with"
	elog "/etc/init.d/chef-client start"
	elog
}
