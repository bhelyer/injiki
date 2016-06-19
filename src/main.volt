module main;

import injiki.gui;

version(Linux) extern(C) i32 setenv(const(char)*, const(char)*, int);

i32 main(string[] args) {
	/* Without this, about half the time the TextView receives no input,
	 * and generates dbus errors on the console. Something to do with ibus
	 * I think, but not sure what the correct solution is.
	 */
	version(Linux) setenv("GTK_IM_MODULE", "xim", 1);
	Window win;
	if (args.length == 1) {
		win = new Window();
	} else {
		win = new Window(args[$-1]);
	}
	if (!win.fileLoaded()) {
		return 1;
	}
	runGui();
	return 0;
}

