module lib.c.gtk;
extern (C):

alias gint = i32;
alias guint = u32;
alias guint32 = u32;
alias gchar = char;
alias gpointer = void*;
alias gboolean = gint;
alias GQuark = guint32;

struct GtkObject {}
struct GtkBuilder {}
struct GtkWidget {}

struct GtkTextView {}
struct GtkTextBuffer {}
struct GtkTextIter {
	/* GtkTextIter is an opaque datatype; ignore all these fields.
	 * Initialize the iter with gtk_text_buffer_get_iter_*
	 * functions
	 */
	/*< private >*/
	gpointer dummy1;
	gpointer dummy2;
	gint dummy3;
	gint dummy4;
	gint dummy5;
	gint dummy6;
	gint dummy7;
	gint dummy8;
	gpointer dummy9;
	gpointer dummy10;
	gint dummy11;
	gint dummy12;
	/* padding */
	gint dummy13;
	gpointer dummy14;
}

struct GtkError {
	GQuark domain;
	gint code;
	gchar* message;
}

GtkWidget* GTK_WIDGET(GtkObject* obj) {
	auto ptr = cast(GtkWidget*)obj;
	if (ptr is null) {
		throw new Exception("GTK_WIDGET failure");
	}
	return ptr;
}

GtkTextView* GTK_TEXT_VIEW(GtkWidget* obj) {
	auto ptr = cast(GtkTextView*)obj;
	if (ptr is null) {
		throw new Exception("GTK_TEXT_VIEW failure");
	}
	return ptr;
}

void gtk_init(int* argc, char*** argv);
GtkBuilder* gtk_builder_new();
guint gtk_builder_add_from_file(GtkBuilder*, const(gchar)*, GtkError*);
GtkObject* gtk_builder_get_object(GtkBuilder*, const(gchar)*);
void gtk_builder_connect_signals(GtkBuilder*, gpointer);
void g_object_unref(gpointer);
void gtk_widget_show(GtkWidget*);
void gtk_main();
void gtk_main_quit();
void g_free(gpointer);

GtkTextBuffer* gtk_text_view_get_buffer(GtkTextView*);

void gtk_text_buffer_set_text(GtkTextBuffer*, const gchar* text, gint len);
gchar* gtk_text_buffer_get_text(GtkTextBuffer*, GtkTextIter* start, GtkTextIter* end, gboolean showHiddenChars);
void gtk_text_buffer_get_bounds(GtkTextBuffer*, GtkTextIter* start, GtkTextIter* end);
