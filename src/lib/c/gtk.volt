module lib.c.gtk;
extern (C):

import core.exception;

/* Bind only as much GTK as injiki needs.
 */

alias gint = i32;
alias guint = u32;
alias gsize = guint;
alias guint8 = u8;
alias guint32 = u32;
alias gchar = char;
alias gpointer = void*;
alias gboolean = gint;
alias gdouble = f64;
alias GQuark = guint32;

struct GdkDisplay {}
struct GdkScreen {}
struct GdkPixbuf {}

struct GtkObject {}
struct GtkBuilder {}
struct GtkWidget {}
struct GtkWindow {}
struct GtkCssProvider {}
struct GtkStyleProvider {}

struct GtkTextView {}
struct GtkTextBuffer {}
struct GtkTextMark {}
struct GtkTextTag {}

struct GtkDialog {}
struct GtkFileChooser {}
struct GtkFileChooserDialog {}

struct GtkSpinButton {}

struct GtkTextIter {
	dummy1: gpointer;
	dummy2: gpointer;
	dummy3: gint;
	dummy4: gint;
	dummy5: gint;
	dummy6: gint;
	dummy7: gint;
	dummy8: gint;
	dummy9: gpointer;
	dummy10: gpointer;
	dummy11: gint;
	dummy12: gint;
	dummy13: gint;
	dummy14: gpointer;
}

struct GtkError {
	domain: GQuark;
	code: gint;
	message: gchar*;
}

fn GTK_WIDGET(obj: GtkObject*) GtkWidget* {
	ptr := cast(GtkWidget*)obj;
	if (ptr is null) {
		throw new Exception("GTK_WIDGET failure");
	}
	return ptr;
}

fn GTK_WINDOW(obj: GtkWidget*) GtkWindow* {
	ptr := cast(GtkWindow*)obj;
	if (ptr is null) {
		throw new Exception("GTK_WINDOW failure");
	}
	return ptr;
}

fn GTK_TEXT_VIEW(obj: GtkWidget*) GtkTextView* {
	ptr := cast(GtkTextView*)obj;
	if (ptr is null) {
		throw new Exception("GTK_TEXT_VIEW failure");
	}
	return ptr;
}

fn GTK_STYLE_PROVIDER(obj: GtkCssProvider*) GtkStyleProvider* {
	ptr := cast(GtkStyleProvider*)obj;
	if (ptr is null) {
		throw new Exception("GTK_STYLE_PROVIDER failure");
	}
	return ptr;
}

fn GTK_DIALOG(obj: GtkWidget*) GtkDialog* {
	ptr := cast(GtkDialog*)obj;
	if (ptr is null) {
		throw new Exception("GTK_DIALOG failure");
	}
	return ptr;
}

fn GTK_DIALOG(obj: GtkObject*) GtkDialog* {
	ptr := cast(GtkDialog*)obj;
	if (ptr is null) {
		throw new Exception("GTK_DIALOG failure");
	}
	return ptr;
}

fn GTK_SPIN_BUTTON(obj: GtkWidget*) GtkSpinButton* {
	ptr := cast(GtkSpinButton*)obj;
	if (ptr is null) {
		throw new Exception("GTK_SPIN_BUTTON failure");
	}
	return ptr;
}

fn GTK_FILE_CHOOSER(obj: GtkWidget*) GtkFileChooser* {
	ptr := cast(GtkFileChooser*)obj;
	if (ptr is null) {
		throw new Exception("GTK_FILE_CHOOSER failure");
	}
	return ptr;
}

enum GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600;

enum {
	GTK_FILE_CHOOSER_ACTION_OPEN,
	GTK_FILE_CHOOSER_ACTION_SAVE,
	GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
	GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER
}

enum {
	GTK_RESPONSE_NONE = -1,
	GTK_RESPONSE_REJECT = -2,
	GTK_RESPONSE_ACCEPT = -3,
	GTK_RESPONSE_DELETE_EVENT = -4,
	GTK_RESPONSE_OK = -5,
	GTK_RESPONSE_CANCEL = -6,
	GTK_RESPONSE_CLOSE = -7,
	GTK_RESPONSE_YES = -8,
	GTK_RESPONSE_NO = -9,
	GTK_RESPONSE_APPLY = -10,
	GTK_RESPONSE_HELP = -11
}

fn gdk_display_get_default() GdkDisplay*;
fn gdk_display_get_default_screen(GdkDisplay*) GdkScreen*;
fn gtk_style_context_add_provider_for_screen(GdkScreen*, GtkStyleProvider*, guint);

fn gtk_init(int*, char***);
fn gtk_builder_new() GtkBuilder*;
fn gtk_builder_add_from_file(GtkBuilder*, const(gchar)*, GtkError*) guint;
fn gtk_builder_add_from_string(GtkBuilder*, const(gchar)*, gsize, void*) guint;
fn gtk_builder_get_object(GtkBuilder*, const(gchar)*) GtkObject*;
fn gtk_builder_connect_signals(GtkBuilder*, gpointer);
fn g_object_unref(gpointer);

fn gtk_widget_show(GtkWidget*);
fn gtk_widget_hide(GtkWidget*);
fn gtk_widget_destroy(GtkWidget*);
fn gtk_widget_grab_focus(GtkWidget *);

fn gtk_main();
fn gtk_main_quit();
fn g_free(gpointer);

fn gtk_window_set_title(GtkWindow*, const(gchar)*);
fn gtk_window_set_icon (GtkWindow *, GdkPixbuf *);
fn gtk_window_set_icon_from_file (GtkWindow *, const gchar *, void **) gboolean;

fn gtk_dialog_run(GtkDialog*) gint;

fn gtk_file_chooser_dialog_new(const(gchar)*, GtkWindow*, i32, const(gchar)*, ...) GtkWidget*;
fn gtk_file_chooser_get_filename(GtkFileChooser*) gchar*;
fn gtk_file_chooser_set_current_name(GtkFileChooser *, const gchar *);
fn gtk_file_chooser_set_filename(GtkFileChooser *, const char *) gboolean;
fn gtk_file_chooser_set_current_folder(GtkFileChooser *, const gchar *) gboolean;

fn gtk_css_provider_new() GtkCssProvider*;
fn gtk_css_provider_get_default() GtkCssProvider*;
fn gtk_css_provider_load_from_data(GtkCssProvider*, const(gchar)*, i32, void*) gboolean;

fn gtk_text_view_get_buffer(GtkTextView*) GtkTextBuffer*;
fn gtk_text_view_set_monospace(GtkTextView*, gboolean);
fn gtk_text_view_scroll_to_mark (GtkTextView *, GtkTextMark *,
	gdouble, gboolean, gdouble, gdouble) GtkTextBuffer*;
fn gtk_text_view_move_mark_onscreen(GtkTextView *, GtkTextMark *) gboolean;
fn gtk_text_buffer_set_text(GtkTextBuffer*, const gchar*, gint);
fn gtk_text_buffer_get_text(GtkTextBuffer*, GtkTextIter*, GtkTextIter*, gboolean) gchar*;
fn gtk_text_buffer_get_bounds(GtkTextBuffer*, GtkTextIter*, GtkTextIter*);
fn gtk_text_buffer_get_iter_at_line_offset(GtkTextBuffer *, GtkTextIter *, gint, gint);
fn gtk_text_buffer_get_iter_at_offset(GtkTextBuffer*, GtkTextIter*, gint);
fn gtk_text_buffer_get_iter_at_line(GtkTextBuffer*, GtkTextIter*, gint);
fn gtk_text_buffer_get_line_count(GtkTextBuffer *) gint;
fn gtk_text_buffer_add_mark(GtkTextBuffer *, GtkTextMark *, const GtkTextIter *);
fn gtk_text_buffer_delete_mark(GtkTextBuffer *, GtkTextMark *);
fn gtk_text_buffer_place_cursor (GtkTextBuffer *, const GtkTextIter *);
fn gtk_text_buffer_create_tag(GtkTextBuffer*, const(gchar)*, const(gchar)*, ...) GtkTextTag*;
fn gtk_text_buffer_apply_tag_by_name(GtkTextBuffer*, const(gchar)*, GtkTextIter*, GtkTextIter*);
fn gtk_text_buffer_remove_tag_by_name(GtkTextBuffer*, const(gchar)*, GtkTextIter*, GtkTextIter*);

fn gtk_text_mark_new(const gchar*, gboolean) GtkTextMark*;

fn gtk_text_iter_set_line(GtkTextIter *, gint);

fn gtk_spin_button_get_value_as_int(GtkSpinButton *) gint;

fn gdk_pixbuf_new_from_inline (gint, const guint8 *, gboolean, void **) GdkPixbuf*;

