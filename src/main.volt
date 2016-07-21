module main;

import injiki.gui;

version(Linux) extern(C) i32 setenv(const(char)*, const(char)*, int);

i32 main(string[] args) {
	Window win;
	if (args.length == 1) {
		win = new Window();
	} else {
		win = new Window(args[$-1]);
	}
	runGui();
	return 0;
}

