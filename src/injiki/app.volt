module injiki.app;

import injiki.text.buffer;
import injiki.ui.control;
import watt.io;
import watt.text.format;
import injiki.core;


class App
{
private:
	mCore: Core;
	mConsole: Control;
	mBuffer: Buffer;


public:
	this()
	{
		mCore = Core.create();
		win := mCore.createWindow();
		win.title = "印字機";
		mConsole = new Control(win);
		mBuffer = new Buffer();
	}

	fn run() i32
	{
		return mCore.loop();
	}
}
