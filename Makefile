
URL=https://minnie.tuhs.org/cgi-bin/utree.pl?file=V7
SRCDIR=prep
PATCHDIR=patches
DESTROOTDIR=/usr/local

# Default action is to show this help message:
.help:
	@echo "Possible targets:"
	@echo "	fetch - retrieve source files from The Unix Heritage Society"
	@echo "	patch - patch source files for use we modern (c89!) compiler"
	@echo "	build - compile source files"
	@echo "	man - show command's man page"
	@echo "	install - install command and man page"
	@echo "	uninstall - uninstall command and man page"
	@echo "	whatis - rebuild whatis database"
	@echo "	distclean - remove the source subdirectory"

fetch:
	@mkdir -p ${SRCDIR}
	@fetch -q "${URL}/usr/src/cmd/prep/makefile" -o - | html2text | tail +2 > ${SRCDIR}/makefile
	@fetch -q "${URL}/usr/src/cmd/prep/prep.h" -o - | html2text | awk 'BEGIN {BODY="no"} /=====/ {getline; BODY="yes"} BODY=="yes" {print}' > ${SRCDIR}/prep.h
	@fetch -q "${URL}/usr/src/cmd/prep/prep0.c" -o - | html2text | awk 'BEGIN {BODY="no"} /=====/ {getline; BODY="yes"} BODY=="yes" {print}' > ${SRCDIR}/prep0.c
	@fetch -q "${URL}/usr/src/cmd/prep/prep1.c" -o - | html2text | awk 'BEGIN {BODY="no"} /=====/ {getline; BODY="yes"} BODY=="yes" {print}' > ${SRCDIR}/prep1.c
	@fetch -q "${URL}/usr/src/cmd/prep/prep2.c" -o - | html2text | awk 'BEGIN {BODY="no"} /=====/ {getline; BODY="yes"} BODY=="yes" {print}' > ${SRCDIR}/prep2.c
	@fetch -q "${URL}/usr/man/man1/prep.1" -o - | html2text | awk 'BEGIN {BODY="no"} /=====/ {getline; BODY="yes"} BODY=="yes" {print}' > ${SRCDIR}/prep.1
	@fetch -q "${URL}/usr/lib/eign" -o - | html2text | tail +2 > ${SRCDIR}/eign

patch: fetch
	@patch < ${PATCHDIR}/makefile.patch
	@patch < ${PATCHDIR}/prep.h.patch
	@patch < ${PATCHDIR}/prep0.c.patch
	@patch < ${PATCHDIR}/prep1.c.patch
	@patch < ${PATCHDIR}/prep2.c.patch

${SRCDIR}/prep: patch
	@cd ${SRCDIR} ; make

build: ${SRCDIR}/prep

${SRCDIR}/prep.1.gz: ${SRCDIR}/prep.1
	@gzip -k9c ${SRCDIR}/prep.1 > ${SRCDIR}/prep.1.gz

install: ${SRCDIR}/prep ${SRCDIR}/prep.1.gz
	install -m 0755 -o root -g wheel ${SRCDIR}/prep ${DESTROOTDIR}/bin
	install -m 0644 -o root -g wheel ${SRCDIR}/prep.1.gz ${DESTROOTDIR}/man/man1
	install -m 0644 -o root -g wheel ${SRCDIR}/eign ${DESTROOTDIR}/etc

uninstall:
	rm -f ${DESTROOTDIR}/bin/prep
	rm -f ${DESTROOTDIR}/man/man1/prep.1.gz
	rm -f ${DESTROOTDIR}/etc/eign

whatis:
	makewhatis

man: ${SRCDIR}/prep.1
	@nroff -mandoc ${SRCDIR}/prep.1

clean:
	@rm -f ${SRCDIR}/*.o

distclean:
	@rm -rf ${SRCDIR}

