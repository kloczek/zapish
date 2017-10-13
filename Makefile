VERSION=0.1

all: man3/zapish.3

man3/zapish.3: zapish.3.xml
	xsltproc \
		--param "man.authors.section.enabled" "1" \
		--stringparam "man.output.base.dir" "0" \
		-nonet http://docbook.sourceforge.net/release/xsl/current/manpages/profile-docbook.xsl $<
