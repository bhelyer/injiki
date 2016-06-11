module ved.gui.window;

import watt.conv;

import lib.c.gtk;

import ved.exception;

enum GLADE_PATH = "ved.glade";

global GtkBuilder* _ved_gtk_builder;

/**
 * Initialise anything not specific to a Window.
 * i.e. GTK itself.
 */
global this() {
	gtk_init(null, null);
	_ved_gtk_builder = gtk_builder_new();
	gtk_builder_add_from_file(_ved_gtk_builder, toStringz(GLADE_PATH), null);
}

global ~this() {
	g_object_unref(cast(gpointer)_ved_gtk_builder);
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
	this(string txt) {
		mWindow = GTK_WIDGET(gtk_builder_get_object(_ved_gtk_builder, "buffer_window"));
		mTextView = GTK_WIDGET(gtk_builder_get_object(_ved_gtk_builder,
			"buffer_textview"));
		mGtkBuffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(mTextView));
		gtk_text_buffer_set_text(mGtkBuffer, toStringz(txt), cast(gint)txt.length);
		gtk_builder_connect_signals(_ved_gtk_builder, cast(gpointer)this);
		gtk_widget_show(mWindow);
	}

	void close() {
	}

	protected GtkWidget* mWindow;
	protected GtkWidget* mTextView;
	protected GtkTextBuffer* mGtkBuffer;
}

/*
 * Callbacks beyond this point.
 */
extern(C) void ved_menu_quit(GtkWidget* widget, gpointer userData) {
	win := cast(Window)userData;
	if (win is null) {
		throw new VedException("failed to retrieve Window in callback");
	}
	gtk_main_quit();
}
