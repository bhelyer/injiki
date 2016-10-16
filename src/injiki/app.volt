module injiki.app;

import injiki.text.buffer;
import injiki.ui.console;
version (Windows) import injiki.ui.win32console;

class App {
	this() {
		mConsole = new Win32Console();
		mConsole.title = "Injiki";
		mBuffer = new Buffer();
	}

	fn run() i32 {
		display("src/main.volt");
		mConsole.getch();
		return 0;
	}

	fn display(filename: string) {
//		colour: Console.Colour;
//		mBuffer.loadFile(filename);
	//	mBuffer.seekRaw(0);
		//w := 80;
		//h := 24;
/+		foreach (y; 0 .. h) {
			buf := new char[](w);
			i: i32 = 0;
			fn cat(c: dchar) {
				if (i >= w) {
					return;
				}
				buf[i++] = cast(char)c;
			}
			
			mBuffer.getUntil('\n', cat);
			mConsole.puts(0, y, colour, colour, cast(string)buf);
		}+/
	}

	private mConsole: Console;
	private mBuffer: Buffer;
}
