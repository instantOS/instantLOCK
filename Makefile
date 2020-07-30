# instantlock - simple screen locker
# See LICENSE file for copyright and license details.

include config.mk

SRC = instantlock.c ${COMPATSRC}
OBJ = ${SRC:.c=.o}

all: options instantlock

options:
	@echo instantlock build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk arg.h util.h

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

instantlock: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f instantlock ${OBJ} instantlock-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p instantlock-${VERSION}
	@cp -R LICENSE Makefile README instantlock.1 config.mk \
		${SRC} explicit_bzero.c config.def.h arg.h util.h instantlock-${VERSION}
	@tar -cf instantlock-${VERSION}.tar instantlock-${VERSION}
	@gzip instantlock-${VERSION}.tar
	@rm -rf instantlock-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f instantlock ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/instantlock
	@chmod u+s ${DESTDIR}${PREFIX}/bin/instantlock
	@cp -f ilock ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/ilock
	@chmod u+s ${DESTDIR}${PREFIX}/bin/ilock
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" <instantlock.1 >${DESTDIR}${MANPREFIX}/man1/instantlock.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/instantlock.1
	@echo installing dbus service and interface to ${DESTDIR}${DBUS_SERVICES_INSTALL_DIR}
	@install -Dm 644 dbus/org.instantos.instantlock.service ${DESTDIR}${DBUS_SERVICES_INSTALL_DIR}/org.instantos.instantlock.service
	@install -Dm 644 dbus/org.instantos.instantLOCK.xml ${DESTDIR}${DBUS_INTERFACES_INSTALL_DIR}/org.instantos.instantLOCK.xml

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/instantlock
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/instantlock.1
	@echo uninstalling dbus service and interface from ${DESTDIR}${DBUS_SERVICES_INSTALL_DIR}
	@rm -f ${DESTDIR}${DBUS_SERVICES_INSTALL_DIR}/org.instantos.instantlock.service
	@rm -f ${DESTDIR}${DBUS_INTERFACES_INSTALL_DIR}/org.instantos.instantLOCK.xml

.PHONY: all options clean dist install uninstall
