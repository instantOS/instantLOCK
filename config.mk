# instantlock version
VERSION = 1.4

# Customize below to fit your system

# paths
PREFIX = /usr
MANPREFIX = ${PREFIX}/share/man
DBUS_SERVICES_INSTALL_DIR = ${PREFIX}/share/dbus-1/services
DBUS_INTERFACES_INSTALL_DIR = ${PREFIX}/share/dbus-1/interfaces
DBUS_CONFIG_INSTALL_DIR = ${PREFIX}/etc/dbus-1/system.d
ARGTABLE3_INCLUDE_DIR = ${PREFIX}/usr/include
ARGTABLE3_LIB_DIR = ${PREFIX}/usr/lib
GLIB2_CFLAGS = `pkg-config --cflags glib-2.0` `pkg-config --cflags gio-unix-2.0`
GLIB2_LDFLAGS = `pkg-config --libs glib-2.0` `pkg-config --libs gio-unix-2.0`

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# includes and libs
INCS = -I. -I/usr/include -I${X11INC} -I${ARGTABLE3_INCLUDE_DIR} ${GLIB2_CFLAGS}
LIBS = -L/usr/lib -lc -lcrypt -L${X11LIB} -L${ARGTABLE3_LIB_DIR} ${GLIB2_LDFLAGS} -lX11 -lXext -lXrandr -lXinerama -largtable3

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
