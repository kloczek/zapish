VERSION=0.1

libexecdir=/usr/libexec

all: zapish.inc.3

zapish.inc.3: zapish.inc.xml
	xsltproc \
		--param "man.authors.section.enabled" "1" \
		--stringparam "man.output.base.dir" "0" \
		-nonet http://docbook.sourceforge.net/release/xsl/current/manpages/profile-docbook.xsl $<
