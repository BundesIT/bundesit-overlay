# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/rubygems/rubygems-7.ebuild,v 1.1 2013/12/26 09:31:29 graaff Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20 ruby21 jruby"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for rubygems"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
ruby_targets_jruby?  ( dev-ruby/rubygems[ruby_targets_jruby] )
ruby_targets_ruby18? ( dev-ruby/rubygems[ruby_targets_ruby18] )
ruby_targets_ruby19? ( dev-ruby/rubygems[ruby_targets_ruby19] )
ruby_targets_ruby20? ( dev-ruby/rubygems[ruby_targets_ruby20] )
ruby_targets_ruby21? ( dev-ruby/rubygems[ruby_targets_ruby21] ) "

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
