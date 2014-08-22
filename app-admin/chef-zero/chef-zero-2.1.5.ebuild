# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
USE_RUBY="ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"


inherit ruby-fakegem user

DESCRIPTION="Self-contained, easy-setup, fast-start in-memory Chef server for testing and solo setup purposes"
HOMEPAGE="https://github.com/opscode/chef-zero"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""


# specs have various indempotency issues which result in the global Chef::Config
# object to be replaced and subsequently fails other specs. Revisit this later.
#RESTRICT="test"

ruby_add_rdepend "dev-ruby/hashie dev-ruby/json dev-ruby/mixlib-log dev-ruby/rack"
