module injiki.app;

import injiki.text.buffer;
import injiki.ui.console;
import injiki.ui.sdlconsole;
import watt.io;
import watt.text.format;


class App
{
private:
	mConsole: SdlConsole;
	mBuffer: Buffer;


public:
	this()
	{
		mConsole = new SdlConsole();
		mConsole.title = "印字機";
		mBuffer = new Buffer();
	}

	fn run() i32
	{
		mConsole.loop();
		return 0;
	}
}
