module main;

import injiki.gui;

i32 main(string[] args) {
	if (args.length == 1) {
		return 0;
	}
	win := new Window(args[$-1]);
	runGui();
	return 0;
}

