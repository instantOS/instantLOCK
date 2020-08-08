#include <stdlib.h>
#include <gio/gio.h>
#include <glib.h>
#include <glib/gprintf.h>

#ifdef G_OS_UNIX
#include <gio/gunixfdlist.h>
/* For STDOUT_FILENO */
#include <unistd.h>
#endif

#include "lock.h"

/* ---------------------------------------------------------------------------------------------------- */

static GDBusNodeInfo *introspection_data = NULL;

/* Introspection data for the service we are exporting */
static const gchar introspection_xml[] =
"  <node>"
"    <interface name='org.instantos.instantLOCK'>"
"        <method name='Lock'>"
"            <arg name='message' direction='in' type='s'>"
"                <doc:doc>"
"                    <doc:summary>The message to print.</doc:summary>"
"                </doc:doc>"
"            </arg>"
"            <arg name='oneKey' direction='in' type='b'>"
"                <doc:doc>"
"                    <doc:summary>Press any key to unlock.</doc:summary>"
"                </doc:doc>"
"            </arg>"
"            <doc:doc>"
"                <doc:description>"
"                    <doc:para>Locks the screen.</doc:para>"
"                </doc:description>"
"            </doc:doc>"
"        </method>"
"        <signal name='Locked'>"
"            <doc:doc>"
"                <doc:description>"
"                    <doc:para>Emitted if the user locked the screen.</doc:para>"
"                </doc:description>"
"            </doc:doc>"
"        </signal>"
"        <signal name='Unlocked'>"
"            <doc:doc>"
"                <doc:description>"
"                    <doc:para>Emitted if the user successfully unlocked the screen.</doc:para>"
"                </doc:description>"
"            </doc:doc>"
"        </signal>"
"    </interface>"
"  </node>";

/* ---------------------------------------------------------------------------------------------------- */

	static void
handle_method_call (GDBusConnection       *connection,
		const gchar           *sender,
		const gchar           *object_path,
		const gchar           *interface_name,
		const gchar           *method_name,
		GVariant              *parameters,
		GDBusMethodInvocation *invocation,
		gpointer               user_data)
{
	if (g_strcmp0 (method_name, "Lock") == 0)
	{
		const gchar *message;
		gboolean oneKey;
		g_variant_get (parameters, "(sb)", &message, &oneKey);
		fprintf(stderr, "Received Lock Call with args : message `%s`, oneKey : `%d`\n", message, oneKey);
		lock(message, oneKey, 0, NULL);

	} else {
		fprintf(stderr, "Unknown method name : %s\n", method_name);
	}
/* ERROR */
/* g_dbus_method_invocation_return_dbus_error (invocation, */
/*                                             "org.gtk.GDBus.NotOnUnix", */
/*                                             "Your OS does not support file descriptor passing"); */
}

static GVariant *
handle_get_property (GDBusConnection  *connection,
		const gchar      *sender,
		const gchar      *object_path,
		const gchar      *interface_name,
		const gchar      *property_name,
		GError          **error,
		gpointer          user_data)
{
	GVariant *ret;

	ret = NULL;
	/* ret = g_variant_new_string ("DeLorean"); */

	return ret;
}

	static gboolean
handle_set_property (GDBusConnection  *connection,
		const gchar      *sender,
		const gchar      *object_path,
		const gchar      *interface_name,
		const gchar      *property_name,
		GVariant         *value,
		GError          **error,
		gpointer          user_data)
{
	return TRUE;
}


/* for now */
static const GDBusInterfaceVTable interface_vtable =
{
	handle_method_call,
	handle_get_property,
	handle_set_property
};

/* ---------------------------------------------------------------------------------------------------- */

	static void
on_bus_acquired (GDBusConnection *connection,
		const gchar     *name,
		gpointer         user_data)
{
	guint registration_id;

	registration_id = g_dbus_connection_register_object (connection,
			"/org/instantos/InstantLock",
			introspection_data->interfaces[0],
			&interface_vtable,
			NULL,  /* user_data */
			NULL,  /* user_data_free_func */
			NULL); /* GError** */
	g_assert (registration_id > 0);

}

	static void
on_name_acquired (GDBusConnection *connection,
		const gchar     *name,
		gpointer         user_data)
{
	fprintf(stderr, "[log] Name `%s` acquired\n", name);
}

	static void
on_name_lost (GDBusConnection *connection,
		const gchar     *name,
		gpointer         user_data)
{
	fprintf(stderr, "[log] Name `%s` lost\n", name);
	exit (1);
}

void
dbus_listen ()
{
	guint owner_id;
	GMainLoop *loop;

	/* We are lazy here - we don't want to manually provide
	 * the introspection data structures - so we just build
	 * them from XML.
	 */
	introspection_data = g_dbus_node_info_new_for_xml (introspection_xml, NULL);
	g_assert (introspection_data != NULL);

	owner_id = g_bus_own_name (G_BUS_TYPE_SESSION,
			"org.instantos.instantLock",
			G_BUS_NAME_OWNER_FLAGS_NONE,
			on_bus_acquired,
			on_name_acquired,
			on_name_lost,
			NULL,
			NULL);

	loop = g_main_loop_new (NULL, FALSE);
	g_main_loop_run (loop);

	g_bus_unown_name (owner_id);

	g_dbus_node_info_unref (introspection_data);
}

