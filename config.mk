# instantlock version
VERSION = 1.4

# Customize below to fit your system

# paths
PREFIX = /usr
MANPREFIX = ${PREFIX}/share/man
DBUS_SERVICES_INSTALL_DIR = ${PREFIX}/share/dbus-1/services
DBUS_INTERFACES_INSTALL_DIR = ${PREFIX}/share/dbus-1/interfaces
ARGTABLE3_INCLUDE_DIR = ${PREFIX}/usr/include
ARGTABLE3_LIB_DIR = ${PREFIX}/usr/lib

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# includes and libs
INCS = -I. -I/usr/include -I${X11INC} -I${ARGTABLE3_INCLUDE_DIR}
LIBS = -L/usr/lib -lc -lcrypt -L${X11LIB} -L${ARGTABLE3_LIB_DIR} -lX11 -lXext -lXrandr -lXinerama -largtable3

# flags
CPPFLAGS += -DVERSION=\"${VERSION}\" -D_DEFAULT_SOURCE -DHAVE_SHADOW_H
CFLAGS += -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
LDFLAGS += -s ${LIBS}
COMPATSRC = explicit_bzero.c

# On OpenBSD and Darwin remove -lcrypt from LIBS
#LIBS = -L/usr/lib -lc -L${X11LIB} -lX11 -lXext -lXrandr
# On *BSD remove -DHAVE_SHADOW_H from CPPFLAGS
# On NetBSD add -D_NETBSD_SOURCE to CPPFLAGS
#CPPFLAGS += -DVERSION=\"${VERSION}\" -D_BSD_SOURCE -D_NETBSD_SOURCE
# On OpenBSD set COMPATSRC to empty
#COMPATSRC =

# compiler and linker
CC = cc
