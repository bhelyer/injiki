module injiki.gui.window;

import watt.conv;
import watt.io.file;
import watt.io.streams;

import lib.c.gtk;

import injiki.exception;

global string GLADE = import("injiki.glade");
// GTK <3.20 == GtkTextView, Gtk >= 3.20 == textview
enum CSS = "GtkTextView, textview {
	font-family: monospace;
}";

global GtkBuilder* _injiki_gtk_builder;

/**
 * Initialise anything not specific to a Window.
 * i.e. GTK itself.
 */
global this() {
	gtk_init(null, null);
	_injiki_gtk_builder = gtk_builder_new();
	gtk_builder_add_from_string(_injiki_gtk_builder, toStringz(GLADE), 
		cast(gsize)GLADE.length, null);
	loadCSS(CSS);
}

global ~this() {
	g_object_unref(cast(gpointer)_injiki_gtk_builder);
}

void loadCSS(string s) {
	str := toStringz(s);
	provider := gtk_css_provider_new();
	display := gdk_display_get_default();
	screen := gdk_display_get_default_screen(display);
	gtk_style_context_add_provider_for_screen(screen,
		GTK_STYLE_PROVIDER(provider),
		GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
	gtk_css_provider_load_from_data(provider, str, cast(int)s.length, null);
	g_object_unref(cast(gpointer)provider);
}

/**
 * Once you've created the Windows you want initially, run this.
 * It'll run until the user quits the GUI.
 */
void runGui() {
	gtk_main();
}

/**
 * Represents a Window that displays text.
 * Eventually, multiple of these should be able to be
 * created.
 */
class Window {
	this(string filename) {
		open(filename);
	}

	void open(string filename) {
		string txt;
		if (exists(filename)) {
			txt = cast(string)read(filename);
		}
		mFilename = filename;

		mWindow = GTK_WIDGET(gtk_builder_get_object(_injiki_gtk_builder, "buffer_window"));
		mTextView = GTK_WIDGET(gtk_builder_get_object(_injiki_gtk_builder,
			"buffer_textview"));
		gtk_text_view_set_monospace(GTK_TEXT_VIEW(mTextView), true);
		mGtkBuffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(mTextView));
		gtk_text_buffer_set_text(mGtkBuffer, toStringz(txt), cast(gint)txt.length);
		gtk_builder_connect_signals(_injiki_gtk_builder, cast(gpointer)this);
		gtk_widget_show(mWindow);
	}

	void close() {
	}

	protected string mFilename;

	protected GtkWidget* mWindow;
	protected GtkWidget* mTextView;
	protected GtkTextBuffer* mGtkBuffer;
}

/*
 * Callbacks beyond this point.
 */

Window getWindow(gpointer ptr) {
	win := cast(Window)ptr;
	if (win is null) {
		throw new InjikiException("failed to retrieve window in callback");
	}
	return win;
}

extern(C) void injiki_quit_cb(GtkWidget* widget, gpointer userData) {
	gtk_main_quit();
}

extern(C) void injiki_save_cb(GtkWidget* widget, gpointer userData) {
	win := getWindow(userData);
	ofs := new OutputFileStream(win.mFilename);
	scope(exit) ofs.close();
	GtkTextIter a, b;
	gtk_text_buffer_get_bounds(win.mGtkBuffer, &a, &b);
	const(char)* str = gtk_text_buffer_get_text(win.mGtkBuffer, &a, &b, false);
	ofs.write(toString(str));
	g_free(cast(void*)str);
}

extern(C) void injiki_open_cb(GtkWidget* widget, gpointer userData) {
	win := getWindow(userData);
	act := GTK_FILE_CHOOSER_ACTION_OPEN;
	openstr := toStringz("_Open");
	closestr := toStringz("_Cancel");
	dlg := gtk_file_chooser_dialog_new("Open File", GTK_WINDOW(win.mWindow), act,
		closestr, GTK_RESPONSE_CANCEL, openstr, GTK_RESPONSE_ACCEPT, cast(void*)null);
	res := gtk_dialog_run(GTK_DIALOG(dlg));
	if (res == GTK_RESPONSE_ACCEPT) {
		char* fname = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dlg));
		win.open(toString(fname));
		g_free(cast(void*)fname);
	}
	gtk_widget_destroy(dlg);
}
