# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby19 ruby20 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="gem to install the libyajl2 c-library for distributions which do not have it"
HOMEPAGE="https://github.com/lamont-granquist/libyajl2-gem"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""
ruby_add_rdepend "
	>=dev-ruby/ffi-1.9
	>=dev-ruby/mime-types-1.16"
