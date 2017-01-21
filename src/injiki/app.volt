module injiki.app;

import injiki.text.buffer;
import injiki.ui.console;
import injiki.ui.windowconsole;
import watt.io;
import watt.text.format;
import injiki.core;


class App
{
private:
	mCore: Core;
	mConsole: WindowConsole;
	mBuffer: Buffer;


public:
	this()
	{
		mCore = Core.create();
		win := mCore.createWindow();
		mConsole = new WindowConsole(win);
		mConsole.title = "印字機";
		mBuffer = new Buffer();
	}

	fn run() i32
	{
		return mCore.loop();
	}
}
