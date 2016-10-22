module injiki.app;

import injiki.text.buffer;
import injiki.ui.console;
import injiki.ui.sdlconsole;
import watt.io;
import watt.text.format;

class App {
	this() {
		mConsole = new SdlConsole();
		mConsole.title = "Injiki";
		mBuffer = new Buffer();
	}

	fn run() i32 {
		mConsole.loop();
		return 0;
	}

	fn display(filename: string) {
	/+
		colour: Console.Colour;
		mBuffer.loadFile(filename);
		mBuffer.seekRaw(0);
		console := cast(Win32Console)mConsole;  // TODO: bug
		w := console.width;
		h := console.height;
		writefln("%s %s", w, h);
		buf := new char[](w);
		foreach (y; 0 .. h) {
			if (mBuffer.eof()) {
//				break;
			}
			i: i32 = 0;
			fn cat(c: dchar) {
				if (i >= w) {
					return;
				}
				buf[i++] = cast(char)c;
			}
			
			mBuffer.getUntil('\n', cat);
			if (buf.length > 0) {
				mConsole.puts(0, y, colour, colour, format("hello world %s", y));//cast(string)buf[0 .. i]);
			}
			if (!mBuffer.eof()) {
				mBuffer.getc();
			}
			/+if (buf.length > 0) {
				mConsole.puts(0, y, colour, colour, cast(string)buf);
			}
			if (!mBuffer.eof()) {
				mBuffer.getc();  // Eat the newline.
			}+/
		}+/
	}

	private mConsole: SdlConsole;
	private mBuffer: Buffer;
}
