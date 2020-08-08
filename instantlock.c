/* See LICENSE file for license details. */

#include <stdio.h>
#include <argtable3.h>

#include "lock.h"
#include "dbusadapter.h"

int
main(int argc, char **argv) {
	Display *dpy;
	char **font_names;
	int count_fonts;
	int oneButton = onebutton;
	int runCommand = 0;
	const char* lock_message = message;
	struct arg_lit *help, *version, *fonts, *anyKey, *dbus;
	struct arg_str *message, *command;
	struct arg_end *end;


	void* argtable[] = {
		help		= arg_litn(NULL, "help", 0, 1, "display this help and exit"),
		version		= arg_litn("v", "version", 0, 1, "print instantlock version"),
		fonts		= arg_litn("f", "fonts", 0, 1, "list available fonts"),
		anyKey		= arg_litn("o", NULL, 0, 1, "press any key"),
		dbus		= arg_litn("d", "dbus", 0, 1, "run the dbus service"),
		message		= arg_str0("m", "message", "MESSAGE", "display the specified message"),
		command		= arg_strn(NULL, NULL, "COMMAND [ARGS ...]",0,argc+2,NULL),
		end			= arg_end(20)
	};

	int nerrors;
	int exitcode = 0;
	char progname[] = "instantlock";

	/* verify the argtable[] entries were allocated sucessfully */
    if (arg_nullcheck(argtable) != 0)
	{
		/* NULL entries were detected, some allocations must have failed */
		printf("%s: insufficient memory\n",progname);
		exitcode = 1;
		goto exit;
	}

	nerrors = arg_parse(argc,argv,argtable);

	/* special case: '--help' takes precedence over error reporting */
    if (help->count > 0)
    {
        printf("Usage: %s", progname);
        arg_print_syntax(stdout, argtable, "\n");
        printf("Demonstrate command-line parsing in argtable3.\n\n");
        arg_print_glossary(stdout, argtable, "  %-25s %s\n");
		exitcode = 0;
		goto exit;
    }

	if (command->count > 0)
		runCommand = 1;

	/* If the parser returned any errors then display them and exit */
    if (nerrors > 0)
    {
        /* Display the error details contained in the arg_end struct.*/
        arg_print_errors(stdout, end, progname);
        printf("Try '%s --help' for more information.\n", progname);
        exitcode = 1;
        goto exit;
    }
	if (version->count > 0)
	{
		fputs("instantlock-"VERSION"\n", stderr);
		exitcode = 0;
		goto exit;
	}
	if (message->count > 0)
	{
		lock_message = message->sval[0];
	}
	if (anyKey->count > 0)
	{
		oneButton = 1;
		lock_message = "Press key to Unlock";
	}
	if (fonts->count > 0)
	{
		if (!(dpy = XOpenDisplay(NULL)))
			die("instantlock: cannot open display\n");
		font_names = XListFonts(dpy, "*", 10000 /* list 10000 fonts*/, &count_fonts);
		int i = 0;
		for (i=0; i<count_fonts; i++) {
			fprintf(stderr, "%s\n", *(font_names+i));
		}
		exitcode = 0;
		goto exit;
	}
	if (dbus->count > 0) {
		dbus_listen();
		exitcode = 0;
		goto exit;
	}

	if (command->count > 0) {
		runCommand = 1;
	}

	fprintf(stderr, "lock message : %s\n", lock_message);
	fprintf(stderr, "oneButton : %d\n", oneButton);
	fprintf(stderr, "runCommand : %d\n", runCommand);

	lock(lock_message, oneButton, runCommand, argv);

exit:
	arg_freetable(argtable, sizeof(argtable) / sizeof(argtable[0]));
	return exitcode;
}
