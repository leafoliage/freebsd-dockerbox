PREFIX?=/usr/local
LOCALBASE?=/usr/local
GUEST_ROOT?=$(LOCALBASE)/share/dockerbox
RECOVERY_METHOD?=restart_vmm

BINDIR=$(DESTDIR)$(PREFIX)/sbin
ETCDIR=$(DESTDIR)$(PREFIX)/etc
RCDIR=$(ETCDIR)/rc.d
SHAREDIR=$(DESTDIR)$(PREFIX)/share
MANDIR=$(DESTDIR)$(PREFIX)/man

MKDIR=/bin/mkdir
LN=/bin/ln
SED=/usr/bin/sed
CP=/bin/cp
CHMOD=/bin/chmod
GZIP=/usr/bin/gzip
GIT=$(LOCALBASE)/bin/git
SHELLCHECK=$(LOCALBASE)/bin/shellcheck
FETCH=/usr/bin/fetch

.if !defined(VERSION)
VERSION!=	$(GIT) describe --tags --always
.endif

.if defined(GUEST_MAN)
_GUEST_MAN=	${GUEST_MAN}
.else
_GUEST_MAN=	../man8/dockerbox.8.gz
.endif

SUB_LIST=	PREFIX=$(PREFIX) \
		LOCALBASE=$(LOCALBASE) \
		VERSION=$(VERSION) \
		GUEST_ROOT=$(GUEST_ROOT)

.if ${RECOVERY_METHOD} == restart_vmm
SUB_LIST+=	SUSPEND_CMD=/usr/bin/true \
		RESUME_CMD='$${command} restart vmm'
.elif ${RECOVERY_METHOD} == suspend_guest
SUB_LIST+=	SUSPEND_CMD='$${command} stop guest' \
		RESUME_CMD='$${command} start guest'
.elif ${RECOVERY_METHOD} == suspend_vmm
SUB_LIST+=	SUSPEND_CMD='$${command} stop vmm' \
		RESUME_CMD='$${command} start vmm'
.else
SUB_LIST+=	SUSPEND_CMD=/usr/bin/true \
		RESUME_CMD=/usr/bin/true
.endif

GATE!=/usr/bin/netstat -nr | /usr/bin/grep default | /usr/bin/awk '{ print $$4 }'
.if $(GATE) == ""
GATE=ue0
.endif
SUB_LIST+=	EXT_IF=$(GATE)

_SUB_LIST_EXP= 	${SUB_LIST:S/$/!g/:S/^/ -e s!%%/:S/=/%%!/}
_SCRIPT_SRC=	sbin/dockerbox

install:
	$(MKDIR) -p $(BINDIR)
	$(SED) ${_SUB_LIST_EXP} ${_SCRIPT_SRC} > $(BINDIR)/dockerbox
	$(CHMOD) 555 $(BINDIR)/dockerbox

	$(MKDIR) -p $(ETCDIR)/dockerbox
	$(SED) ${_SUB_LIST_EXP} etc/dockerbox.conf > $(ETCDIR)/dockerbox/dockerbox.conf

	$(MKDIR) -p $(RCDIR)
	$(SED) ${_SUB_LIST_EXP} rc.d/dockerbox > $(RCDIR)/dockerbox
	$(CHMOD) 555 $(RCDIR)/dockerbox

image:
	$(FETCH) https://github.com/leafoliage/freebsd-dockerbox/releases/download/disk-0.1.0/dockerbox-img.tar.gz
	$(MKDIR) -p $(SHAREDIR)/dockerbox
	$(TAR) -xf dockerbox-img.tar.gz -C $(SHAREDIR)/dockerbox && $(RM) dockerbox-img.tar.gz

.MAIN: clean

clean: ;
