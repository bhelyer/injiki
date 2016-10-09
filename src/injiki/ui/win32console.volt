module injiki.ui.win32console;

import core.windows;
import watt.conv;

import injiki.ui.console;

/**
 * An implementation of the Console interface using win32.
 */
class Win32Console : Console {
	this() {
		mOutputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
		mInputHandle = GetStdHandle(STD_INPUT_HANDLE);
		assert(mOutputHandle !is null);
		assert(mInputHandle !is null);
	}

	override @property fn width() i32 {
		return 0;
	}

	override @property fn height() i32 {
		return 0;
	}

	override @property fn title(s: string) bool {
		return cast(bool)SetConsoleTitleA(toStringz(s));
	}

	override fn putc(x: i32, y: i32, fg: Console.Colour, bg: Console.Colour, c: dchar) {
		coord: COORD;
		coord.x = cast(SHORT)x;
		coord.y = cast(SHORT)y;
		SetConsoleCursorPosition(mOutputHandle, coord);
		DWORD written;
		WriteConsoleA(mOutputHandle, cast(const(void)*)&c, 1, &written, null);
	}
	
	override fn getch() dchar {
		char c;
		readChars: DWORD;
		ReadConsoleA(mInputHandle, cast(LPVOID)&c, 1, &readChars, null);
		return c;
	}

	override fn refresh() {
	}

	protected mOutputHandle: HANDLE;
	protected mInputHandle: HANDLE;
}