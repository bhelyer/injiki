module injiki.gui.window;

import watt.conv;
import watt.path;
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
		openWindow();
		loadFile(filename);
	}

	this() {
		openWindow();
		title = "印字機 - Untitled";
	}

	bool fileLoaded() {
		return mFilename != "";
	}

	void loadFile(string filename) {
		string txt;
		if (exists(filename)) {
			txt = cast(string)read(filename);
		}
		mFilename = filename;
		title = "印字機 - " ~ filename;
		gtk_text_buffer_set_text(mGtkBuffer, toStringz(txt),
			cast(gint)txt.length);
	}

	void openWindow() {
		mWindow = GTK_WIDGET(gtk_builder_get_object(_injiki_gtk_builder,
			"buffer_window"));
		mTextView = GTK_WIDGET(gtk_builder_get_object(_injiki_gtk_builder,
			"buffer_textview"));
		gtk_text_view_set_monospace(GTK_TEXT_VIEW(mTextView), true);
		mGtkBuffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(mTextView));
		gtk_builder_connect_signals(_injiki_gtk_builder, cast(gpointer)this);
		gtk_widget_show(mWindow);
	}

	void close() {
	}

	/**
	 * Scroll to the given line in the buffer.
	 * If given line is less than 1, it will scroll to the first line.
	 * If given line is greater or equal to the number of lines, it will
	 * scroll to the last line.
	 */
	void scrollToLine(int line) {
		line--;  // Buffer counts from zero, humans from one.
		i32 lineCount = gtk_text_buffer_get_line_count(mGtkBuffer);
		if (line >= lineCount) {
			line = lineCount - 1;
		}
		if (line < 0) {
			line = 0;
		}
		tv := GTK_TEXT_VIEW(mTextView);
		GtkTextIter iter;
		gtk_text_buffer_get_iter_at_line_offset(mGtkBuffer,
			&iter, line, 0);
		scroll2mark := gtk_text_mark_new(null, false);
		gtk_text_buffer_add_mark(mGtkBuffer, scroll2mark, &iter);
		gtk_text_view_scroll_to_mark(tv, scroll2mark, 0.0, true, 0.0, 0.17);
		gtk_text_buffer_place_cursor(mGtkBuffer, &iter);
		gtk_text_buffer_delete_mark(mGtkBuffer, scroll2mark);
	}

	/**
	 * Set the window title.
	 */
	@property void title(string s) {
		cstr := toStringz(s);
		gtk_window_set_title(GTK_WINDOW(mWindow), cstr);
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
	if (win.mFilename == "") {
		injiki_saveas_cb(widget, userData);
		return;
	}
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
		closestr, GTK_RESPONSE_CANCEL, openstr, GTK_RESPONSE_ACCEPT, null);

	startPath: string;
	if (win.mFilename != "") {
		startPath = dirName(fullPath(win.mFilename));
	} else {
		startPath = getExecDir();
	}

	gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER(dlg),
		toStringz(startPath));
	res := gtk_dialog_run(GTK_DIALOG(dlg));
	if (res == GTK_RESPONSE_ACCEPT) {
		char* fname = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dlg));
		win.loadFile(toString(fname));
		g_free(cast(void*)fname);
	}
	gtk_widget_destroy(dlg);
}

extern(C) void injiki_saveas_cb(GtkWidget* widget, gpointer userData) {
	win := getWindow(userData);
	act := GTK_FILE_CHOOSER_ACTION_SAVE;
	savestr := toStringz("_Save");
	closestr := toStringz("_Cancel");
	dlg := gtk_file_chooser_dialog_new("Save As", GTK_WINDOW(win.mWindow), act,
		closestr, GTK_RESPONSE_CANCEL, savestr, GTK_RESPONSE_ACCEPT, null);
	chooser := GTK_FILE_CHOOSER(dlg);
	if (win.mFilename == "") {
		gtk_file_chooser_set_current_name(chooser, "Untitled");
	} else {
		gtk_file_chooser_set_filename(chooser, toStringz(win.mFilename));
	}
	res := gtk_dialog_run(GTK_DIALOG(dlg));
	if (res == GTK_RESPONSE_ACCEPT) {
		char* fname = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dlg));
		win.mFilename = toString(fname);
		injiki_save_cb(widget, userData);
		win.loadFile(toString(fname));
		g_free(cast(void*)fname);
	}
	gtk_widget_destroy(dlg);
}

extern(C) void injiki_goto_cb(GtkWidget* widget, gpointer userData) {
	win := getWindow(userData);
	dlg := GTK_WIDGET(gtk_builder_get_object(_injiki_gtk_builder, "gotoline_dialog"));
	spin := GTK_WIDGET(gtk_builder_get_object(_injiki_gtk_builder, "gotoline_spinbutton"));
	gtk_widget_grab_focus(spin);
	res := gtk_dialog_run(GTK_DIALOG(dlg));
	if (res == GTK_RESPONSE_ACCEPT) {
		line := cast(i32)gtk_spin_button_get_value_as_int(GTK_SPIN_BUTTON(spin));
		win.scrollToLine(line);
	}
	gtk_widget_hide(dlg);
}
