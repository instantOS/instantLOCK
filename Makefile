# instantlock - simple screen locker
# See LICENSE file for copyright and license details.

include config.mk

SRC = instantlock.c ${COMPATSRC}
OBJ = ${SRC:.c=.o}

all: instantlock


.c.o:
	${CC} -c ${CFLAGS} $<


${OBJ}: config.h config.mk arg.h util.h

config.h:
	cp config.def.h $@


instantlock: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}


clean:
	rm -f instantlock ${OBJ} instantlock-${VERSION}.tar.gz


dist: clean
	mkdir -p instantlock-${VERSION}
	cp -R LICENSE Makefile README instantlock.1 config.mk \
		${SRC} config.def.h arg.h util.h instantlock-${VERSION}
	tar -cf instantlock-${VERSION}.tar instantlock-${VERSION}
	gzip instantlock-${VERSION}.tar
	rm -rf instantlock-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f instantlock ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/instantlock
	chmod u+s ${DESTDIR}${PREFIX}/bin/instantlock
	cp -f ilock ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/ilock
	chmod u+s ${DESTDIR}${PREFIX}/bin/ilock
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" <instantlock.1 >${DESTDIR}${MANPREFIX}/man1/instantlock.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/instantlock.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/instantlock
	rm -f ${DESTDIR}${MANPREFIX}/man1/instantlock.1

.PHONY: all clean dist install uninstall
