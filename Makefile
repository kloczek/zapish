VERSION		= 0.99

libexecdir	= /usr/libexec
pkglibexecdir	= ${libexecdir}/zapish
mandir		= /usr/share/man
man3dir		= ${mandir}/man3

MKDIR_P		= mkdir -p
DESTDIR		=
INSTALL		= /usr/bin/install -c
INSTALL_DATA	= ${INSTALL} -m 644
INSTALL_SCRIPT	= ${INSTALL}

all: zapish.inc.3

zapish.inc.3: zapish.inc.3.xml
	xsltproc \
		--param "man.authors.section.enabled" "1" \
		--stringparam "man.output.base.dir" "0" \
		-nonet http://docbook.sourceforge.net/release/xsl/current/manpages/profile-docbook.xsl $<

install:
	$(MKDIR_P) "$(DESTDIR)$(man3dir)" "$(DESTDIR)$(pkglibexecdir)"
	$(INSTALL_DATA) zapish.inc.3 "$(DESTDIR)$(man3dir)"
	$(INSTALL_DATA) zapish.inc "$(DESTDIR)$(pkglibexecdir)"

dist:
        

rpm:
	
