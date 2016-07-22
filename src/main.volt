module main;

import injiki.gui;

fn main(args: string[]) i32 {
	win: Window;
	if (args.length == 1) {
		win = new Window();
	} else {
		win = new Window(args[$-1]);
	}
	runGui();
	return 0;
}

