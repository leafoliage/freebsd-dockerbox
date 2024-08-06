PREFIX?=/usr/local
LOCALBASE?=/usr/local
GUEST_ROOT?=${LOCALBASE}/share/dockerbox

BINDIR=${DESTDIR}${PREFIX}/sbin
ETCDIR=${DESTDIR}${PREFIX}/etc
RCDIR=${ETCDIR}/rc.d
SHAREDIR=${DESTDIR}${PREFIX}/share
MANDIR=${DESTDIR}${PREFIX}/man

MKDIR=/bin/mkdir
SED=/usr/bin/sed
AWK=/usr/bin/awk
INSTALL=/usr/bin/install
ROUTE=/sbin/route
GREP=/usr/bin/grep
GIT=${LOCALBASE}/bin/git

.if !defined(VERSION)
VERSION!= ${GIT} describe --tags --always
.endif

SUB_LIST= PREFIX=${PREFIX} \
          LOCALBASE=${LOCALBASE} \
          VERSION=${VERSION} \
          GUEST_ROOT=${GUEST_ROOT}

# Use route to get the IPv4 default interface
GATE!= ${ROUTE} -n get -inet default | ${GREP} 'interface:' | ${AWK} '{ print $$2 }'
.if empty(GATE)
GATE=ue0
.endif
SUB_LIST+= EXT_IF=${GATE}

_SUB_LIST_EXP= ${SUB_LIST:S/$/!g/:S/^/ -e s!%%/:S/=/%%!/}

install:
	${MKDIR} -p ${BINDIR}
	${INSTALL} -m 0755 sbin/dockerbox ${BINDIR}/dockerbox

	${MKDIR} -p ${ETCDIR}/dockerbox
	${INSTALL} -m 0755 etc/dockerbox.conf ${ETCDIR}/dockerbox/dockerbox.conf
	${SED} ${_SUB_LIST_EXP} etc/dockerbox.conf > ${ETCDIR}/dockerbox/dockerbox.conf

	${MKDIR} -p ${RCDIR}
	${INSTALL} -m 0755 rc.d/dockerbox ${RCDIR}/dockerbox

	#${MKDIR} -p ${SHAREDIR}/dockerbox
	#${INSTALL} -m 0644 share/disk.img share/device.map ${SHAREDIR}/dockerbox

.MAIN: clean

.PHONY: clean

clean: ;
