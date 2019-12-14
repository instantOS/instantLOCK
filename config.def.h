/* user and group to drop privileges to */
static const char *user = "nobody";
static const char *group = "nobody";

static const char *colorname[NUMCOLS] = {
	[INIT] = "black",	 /* after initialization */
	[INPUT] = "#ff0000",  /* during input */
	[FAILED] = "#0000ff", /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* time in seconds before the monitor shuts down */
static const int monitortime = 5;

/* default message */
static const char * message = "Suckless: Software that sucks less.";

/* text color */
static const char * text_color = "#ffffff";

/* text size (must be a valid size) */
static const char * font_name = "6x10";