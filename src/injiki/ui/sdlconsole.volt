module injiki.ui.sdlconsole;

import watt.conv;
import watt.io;

import amp.sdl2;
import amp.gl;
import amp.gl.loader;

import injiki.ui.console;

class SdlConsole : Console {
	this() {
		initSdl();
		initGl();
	}

	override @property fn width() i32 {
		assert(false);
	}

	override @property fn height() i32 {
		assert(false);
	}

	override @property fn title(s: string) bool {
		SDL_SetWindowTitle(mWindow, toStringz(s));
		return true;
	}

	override fn refresh() {
		assert(false);
	}

	override fn loop() {
		inLoop := true;
		while (inLoop) {
			handleEvents(ref inLoop);
			SDL_GL_SwapWindow(mWindow);
		}
		cleanUpSdl();
	}

	protected fn handleEvents(ref inLoop: bool) {
		SDL_Event e;
		while (SDL_PollEvent(&e)) {
			switch (e.type) {
			case SDL_QUIT: inLoop = false; break;
			default: break;
			}
		}
	}

	override fn outOfBounds(x: i32, y: i32) bool {
		assert(false);
	}

	override fn moveCursor(x: i32, y: i32) {
		assert(false);
	}

	override fn putc(x: i32, y: i32, fg: Console.Colour, bg: Console.Colour, c: dchar) {
		assert(false);
	}

	override fn puts(x: i32, y: i32, fg: Console.Colour, bg: Console.Colour, s: string) {
		assert(false);
	}

	override fn getch() dchar {
		assert(false);
	}

	private fn initSdl() {
		mWindow = SDL_CreateWindow("SdlConsole".ptr,
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
			800, 600, cast(u32)(SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE));
		assert(mWindow !is null);  // TODO: Error handling.

		// We want a core context.
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);

		mContext = SDL_GL_CreateContext(mWindow);
		assert(mContext !is null);
	}

	private fn initGl() {
		gladLoadGL(loadGlFunc);
		writefln("Loaded OpenGL %s.%s (apparently).", GL_MAJOR, GL_MINOR);
	}

	private fn cleanUpSdl() {
		SDL_GL_DeleteContext(mContext);
		SDL_DestroyWindow(mWindow);
	}

	private mWindow: SDL_Window*;
	private mContext: SDL_GLContext;
}

private fn loadGlFunc(name: const(char)*) void* {
	return SDL_GL_GetProcAddress(name);
}
