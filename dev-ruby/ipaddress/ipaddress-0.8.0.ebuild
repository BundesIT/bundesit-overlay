# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

# ruby20, ruby21 → fails tests
USE_RUBY="ruby19 ruby20 jruby"

inherit ruby-fakegem

DESCRIPTION="A library designed to make manipulation of IPv4 and IPv6 addresses both powerful and simple"
HOMEPAGE="http://github.com/bluemonk/ipaddress"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	# Fix deprecated rake task invocation.
	sed -i -e 's:rake/rdoctask:rdoc/task:' Rakefile || die
}
