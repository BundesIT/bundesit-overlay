# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ohai/ohai-6.22.0.ebuild,v 1.1 2014/05/06 06:05:05 graaff Exp $

EAPI=5
USE_RUBY="ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Ohai profiles your system and emits JSON"
HOMEPAGE="http://wiki.opscode.com/display/chef/Ohai"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/ipaddress
	dev-ruby/yajl-ruby
	dev-ruby/mixlib-cli
	dev-ruby/mixlib-config
	dev-ruby/mixlib-log
	dev-ruby/mixlib-shellout
	>=dev-ruby/systemu-2.5.2"

all_ruby_prepare() {
	# Remove the Darwin-specific tests that require additional
	# dependencies.
	rm -rf spec/unit/plugins/darwin || die

	# Avoid the ruby plugin tests because these always execute the
	# system ruby, rather than the current ruby.
	rm -rf spec/unit/plugins/ruby_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install

	doman docs/man/man1/ohai.1
	sed -i -e 's/~> 2.5.2/>= 2.5.2/' ${D}/usr/lib64/ruby/gems/2.0.0/specifications/ohai-7.0.4.gemspec || die
}
