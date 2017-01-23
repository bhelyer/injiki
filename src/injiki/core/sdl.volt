module injiki.core.sdl;


import lib.gl;
import lib.gl.loader;
import amp.sdl2;

import watt.io;
import watt.conv;
import injiki.core;
import injiki.ui.key;


class CoreSDL : Core
{
private:
	mWin: WindowSDL;
	mWindow: SDL_Window*;
	mContext: SDL_GLContext;

	mClose: dg();
	mLooping: bool;
	mCreated: bool;


public:
	this()
	{
		mClose = StubClose;
		mLooping = true;

		initSdl();
		initGl();

		mWin = new WindowSDL(this, mWindow, mContext);
	}

	/**
	 * Signals to the core that the application wants to shut down.
	 *
	 * Backlog of signals may be fired until finally the close signal is fired.
	 */
	override fn signalClose()
	{
		mLooping = false;
	}

	override fn createWindow() Window
	{
		assert(!mCreated);
		mCreated = true;
		return mWin;
	}

	/**
	 * Close signal, fired once when Core enters the shutdown path.
	 */
	override @property fn onClose(dgt: dg())
	{ if (dgt is null) { mClose = StubClose; } else { mClose = dgt; } }

	override int loop()
	{
		while (mLooping) {
			SDL_Event e;

			// Block until next event.
			if (SDL_WaitEvent(&e) != 1) {
				writefln("Error");
				break;
			}

			// Dispatch that event and then drain all other events.
			do {
				handleEvents(ref e);
			} while (SDL_PollEvent(&e));

			// Redraw the window.
			mWin.mRender();
			SDL_GL_SwapWindow(mWindow);
		}

		mWin.mDestroy();
		mClose();

		return 0;
	}


private:
	fn handleEvents(ref e: SDL_Event)
	{
		switch (e.type) {
		case SDL_QUIT: mLooping = false; break;
		case SDL_TEXTINPUT:
			i: size_t;
			for (; i < e.text.text.length && e.text.text[i]; i++) {}
			if (i > 0) {
				mWin.mText(e.text.text[0 .. i]);
			}
			break;
		case SDL_KEYDOWN:
			mWin.mKeyDown(translateKey(e.key.keysym.sym));
			break;
		default:
		}
	}

	fn initSdl()
	{
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

	fn initGl()
	{
		gladLoadGL(loadGlFunc);
		writefln("Loaded OpenGL %s.%s.", GL_MAJOR, GL_MINOR);
	}

	fn cleanUpSdl()
	{
		SDL_GL_DeleteContext(mContext);
		SDL_DestroyWindow(mWindow);
	}

	fn loadGlFunc(name: string) void*
	{
		return SDL_GL_GetProcAddress(name.ptr);
	}

	fn StubClose() {}
}


class WindowSDL : Window
{
private:
	mCore: CoreSDL;
	mWindow: SDL_Window*;
	mContext: SDL_GLContext;

	mDestroy: dg();
	mRender: dg();
	mFocusGained: dg();
	mFocusLost: dg();
	mMove: dg(int, int);
	mButton: dg(int);
	mText: dg(scope const(char)[]);
	mKeyDown: dg(Key);


public:
	this(core: CoreSDL, win: SDL_Window*, ctx: SDL_GLContext)
	{
		mCore = core;
		mWindow = win;
		mContext = ctx;

		mFocusGained = StubFocusGained;
		mFocusLost = StubFocusLost;
		mMove = StubMove;
		mButton = StubButton;
		mText = StubText;
		mKeyDown = StubKeyDown;
	}

	override fn fullscreen()
	{

	}

	override fn destroy()
	{
		mCore.signalClose();
	}

	override @property fn title(s: string)
	{
		SDL_SetWindowTitle(mWindow, toStringz(s));
	}

	override @property fn onDestroy(dgt: dg())
	{ if (dgt is null) { mDestroy = StubDestroy; } else { mDestroy = dgt; } }
	override @property fn onRender(dgt: dg())
	{ if (dgt is null) { mRender = StubRender; } else { mRender = dgt; } }
	override @property fn onFocusGained(dgt: dg())
	{ if (dgt is null) { mFocusGained = StubFocusGained; } else { mFocusGained = dgt; } }
	override @property fn onFocusLost(dgt: dg())
	{ if (dgt is null) { mFocusLost = StubFocusLost; } else { mFocusLost = dgt; } }

	override @property fn onMove(dgt: dg(int, int))
	{ if (dgt is null) { mMove = StubMove; } else { mMove = dgt; } }
	override @property fn onButton(dgt: dg(int))
	{ if (dgt is null) { mButton = StubButton; } else { mButton = dgt; } }
	override @property fn onText(dgt: dg(scope const(char)[]))
	{ if (dgt is null) { mText = StubText; } else { mText = dgt; } }
	override @property fn onKeyDown(dgt: dg(Key))
	{ if (dgt is null) { mKeyDown = StubKeyDown; } else { mKeyDown = dgt; } }

	fn StubDestroy() {}
	fn StubRender() {}
	fn StubFocusGained() {}
	fn StubFocusLost() {}
	fn StubMove(int, int) {}
	fn StubButton(int) {}
	fn StubText(scope const(char)[]) {}
	fn StubKeyDown(Key) {}
}
