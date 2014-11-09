# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools multilib user

DESCRIPTION="Sympa is an opensource mailing list manager. It provides advanced features with a rich and secure web interface."
HOMEPAGE="http://www.sympa.org/"
SRC_URI="http://www.sympa.org/distribution/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="postgres sqlite fcgi dkim ldap soap smime +nls"

LANGUAGES="ar br bg ca cs de el en es et eu fi fr gl hu id it ja ko la ml nb_NO nl oc pl pt pt_BR ro ru sv tr vi zh_CN zh_TW"
for lang in ${LANGUAGES} ; do IUSE+=" linguas_${lang}"; done

RDEPEND="
	dev-perl/Archive-Zip
	dev-perl/Class-Singleton
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-TimeZone
	dev-perl/DBI
	virtual/perl-Digest-MD5
	dev-perl/Email-Simple
	virtual/perl-Encode
	dev-perl/File-Copy-Recursive
	dev-perl/File-NFSLock
	dev-perl/HTML-Format
	dev-perl/HTML-StripScripts-Parser
	dev-perl/HTML-Tree
	virtual/perl-IO
	virtual/perl-Scalar-List-Utils
	dev-perl/libintl-perl
	dev-perl/libwww-perl
	dev-perl/Email-Address
	net-mail/mhonarc
	virtual/perl-MIME-Base64
	dev-perl/MIME-Charset
	dev-perl/MIME-EncWords
	dev-perl/MIME-Lite-HTML
	dev-perl/MIME-tools
	dev-perl/Net-CIDR
	dev-perl/Proc-ProcessTable
	dev-perl/Template-Toolkit
	dev-perl/Term-ProgressBar
	dev-perl/Unicode-LineBreak
	virtual/perl-Time-HiRes
	dev-perl/URI
	dev-perl/XML-LibXML
	dev-perl/Net-Netmask
	dev-perl/Net-DNS
	dev-perl/Crypt-CipherSaber
	dev-perl/Data-Password
	
	postgres? ( dev-perl/DBD-Pg )
	sqlite?   ( dev-perl/DBD-SQLite )
	fcgi?	  ( dev-perl/FCGI www-apache/mod_fcgid www-servers/apache[suexec] )
	dkim?	  ( dev-perl/Mail-DKIM )
	ldap?	  ( dev-perl/perl-ldap )
	soap?	  ( dev-perl/SOAP-Lite )
	smime?	  ( dev-perl/Crypt-OpenSSL-X509 )
	"
DEPEND=">=sys-devel/autoconf-2.69"

SYMPA_HOME="/usr/$(get_libdir)/sympa"

pkg_setup() {
	enewgroup sympa
    enewuser  sympa -1 -1 ${SYMPA_HOME} sympa
}

src_prepare() {
	epatch ${FILESDIR}/00-cfg-gentoo-paths-6.1.23.patch
	epatch ${FILESDIR}/10-db_aliases-6.1.23.patch
	WANT_AUTOCONF=2.69 eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="/etc/sympa" \
		--with-confdir="/etc/sympa" \
		--with-piddir="/run/sympa" \
		--with-user="sympa" \
		--with-group="sympa" \
		--with-docdir="/usr/share/doc/${P}" \
		$(use_enable nls) \
		--prefix="${SYMPA_HOME}"
	
	myconfdef="s/(mysql|ODBC|Oracle|Pg|SQLite|Sybase)/(mysql"
	use postgres && myconfdef+="|Pg"
	use sqlite   && myconfdef+="|SQLite"
	myconfdef+=")/g"

	myconfdef+=";s/%FCGI_ON%/"
	if use fcgi ; then
		myconfdef+="1/"
	else
		myconfdef+="0/"
	fi

	sed -i ${myconfdef} src/lib/confdef.pm
}

src_install() {
  	emake DESTDIR="${D}" install


	for dir in create_list_templates scenari families search_filters \
			   global_task_models mail_tt2 list_task_models web_tt2 db_alias
	do
		keepdir /etc/sympa/${dir}
	done

	for dir in arc list_data spool/digest spool/outgoing spool/moderation \
			   spool/tmp spool/expire spool/task spool/msg spool/auth bounce
	do
		keepdir /usr/lib64/sympa/${dir}
	done

	newinitd "${FILESDIR}/init-6.1.23" sympa
	sed -i "s|%SYMPA_HOME%|${SYMPA_HOME}|" ${D}/etc/init.d/sympa


	dodoc AUTHORS ChangeLog NEWS README README.charset

	rm -rf ${D}/run      # don't install the run dir in a tmpfs ;)
	rm -rf ${D}/etc/rc.d # delete the provided initscriptv
}
