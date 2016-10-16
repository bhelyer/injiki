module injiki.ui.win32console;

import core.exception;
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
		return 80;
	}

	override @property fn height() i32 {
		return 24;
	}

	override @property fn title(s: string) bool {
		return cast(bool)SetConsoleTitleA(toStringz(s));
	}
	
	override fn outOfBounds(x: i32, y: i32) bool {
		return x < 0 || x >= width || y < 0 || y >= height;
	}
	
	override fn moveCursor(x: i32, y: i32) {
		if (outOfBounds(x, y)) {
			throw new Exception("tried to move cursor out of bounds");
		}
		coord: COORD;
		coord.x = cast(SHORT)x;
		coord.y = cast(SHORT)y;
		SetConsoleCursorPosition(mOutputHandle, coord);
	}

	override fn putc(x: i32, y: i32, fg: Console.Colour, bg: Console.Colour, c: dchar) {
		moveCursor(x, y);
		DWORD written;
		WriteConsoleA(mOutputHandle, cast(const(void)*)&c, 1, &written, null);
	}

	override fn puts(x: i32, y: i32, fg: Console.Colour, bg: Console.Colour, s: string) {
		moveCursor(x, y);
		cstr := toStringz(s);
		DWORD written;
		retval := WriteConsoleA(mOutputHandle, cast(const(void)*)cstr,
			cast(DWORD)s.length, &written, null);
		assert(retval == 0);
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
