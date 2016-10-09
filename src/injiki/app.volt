module injiki.app;

import injiki.ui.console;
version (Windows) import injiki.ui.win32console;

class App {
	this() {
		mConsole = new Win32Console();
		mConsole.title = "Injiki";
	}

	int run() {
		mConsole.getch();
		return 0;
	}

	private mConsole: Console;
}