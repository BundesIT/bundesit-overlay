# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
#RESTRICT="test"

ruby_add_rdepend "
	>=dev-ruby/mixlib-config-2.0
	>=dev-ruby/mixlib-cli-1.4
	>=dev-ruby/mixlib-log-1.3
	>=dev-ruby/mixlib-authentication-1.3
	>=dev-ruby/mixlib-shellout-1.4
	dev-ruby/ohai:7.2
	>=dev-ruby/rest-client-1.0.4
	>=dev-ruby/mime-types-1.16:0
	>=dev-ruby/ffi-yajl-1.0:0
	dev-ruby/net-ssh:2.6
	dev-ruby/net-ssh-multi:2
	>=dev-ruby/highline-1.6.9:0
	>=dev-ruby/erubis-2.7:0
	>=dev-ruby/diff-lcs-1.2.4:0

	<app-admin/chef-zero-2.2
	>=app-admin/chef-zero-2.1.4
	
	>=dev-ruby/pry-0.9
	<dev-ruby/pry-1.0

	>=dev-ruby/plist-3.1.0:0
	
	dev-ruby/rdoc
	"

RUBY_PATCHES="00-paludis-fixes.patch"

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
