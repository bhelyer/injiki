module injiki.app;

import injiki.text.buffer;
import injiki.ui.control;
import injiki.ui.components;
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

	fn loadFile(fname: string)
	{
		mBuffer.loadFile(fname);
		mConsole.addComponent(new TextView(mBuffer, 0, 0));
	}

	fn run() i32
	{
		return mCore.loop();
	}
}
