# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby19 ruby20 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby FFI wrapper around YAJL 2.x"
HOMEPAGE="http://github.com/opscode/ffi-yajl"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""
ruby_add_bdepend "
	>=dev-ruby/ffi-1.5
	>=dev-ruby/libyajl2-1.0"

RDEPEND=">=dev-libs/yajl-2.0"

each_ruby_configure() {
    ${RUBY} -Cext/ffi_yajl/ext/encoder extconf.rb || die
    ${RUBY} -Cext/ffi_yajl/ext/parser extconf.rb || die
}

each_ruby_compile() {
	find . -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-Wl,--no-undefined\s*::' || die "--no-undefined removal failed"

    emake -C ext/ffi_yajl/ext/encoder V=1
    emake -C ext/ffi_yajl/ext/parser V=1
    cp ext/ffi_yajl/ext/encoder/encoder.so lib || die
    cp ext/ffi_yajl/ext/parser/parser.so lib || die
}

