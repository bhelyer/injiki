module injiki.core.sdl;


import lib.gl;
import lib.gl.loader;
import amp.sdl2;

import watt.io;
import watt.conv;
import injiki.core;
import injiki.ui.key;
import injiki.ui.gl.timer;


class CoreSDL : Core
{
private:
	mWin: WindowSDL;
	mWindow: SDL_Window*;
	mContext: SDL_GLContext;

	mClose: dg();
	mLooping: bool;
	mCreated: bool;
	mTimer: Timer;


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
		counter: i32;
		accum: u64;
		mTimer.setup();

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
			mTimer.start();
			mWin.mRender();
			mTimer.stop();
			SDL_GL_SwapWindow(mWindow);

			val: u64;
			if (mTimer.getValue(out val)) {
				val /= (1_000_000_000 / 1_000_000u);
				accum += val;
				counter++;
			}
			if (counter == 8) {
				accum /= 8;
				writefln("Avg %s.%03sms", accum / 1000, accum % 1000);
				counter = 0; accum = 0;
			}
		}

		mTimer.close();
		mWin.mDestroy();
		mClose();

		return 0;
	}


private:
	fn handleEvents(ref e: SDL_Event)
	{
		switch (e.type) {
		case SDL_TEXTINPUT:
			i: size_t;
			for (; i < e.text.text.length && e.text.text[i]; i++) {}
			if (i > 0) {
				mWin.mText(e.text.text[0 .. i]);
			}
			break;
		case SDL_KEYUP:
			mWin.mKeyUp(translateKey(e.key.keysym.sym), e.key.keysym.mod);
			break;
		case SDL_KEYDOWN:
			mWin.mKeyDown(translateKey(e.key.keysym.sym), e.key.keysym.mod);
			break;
		case SDL_QUIT:
			mLooping = false;
			break;
		default:
		}
	}

	fn initSdl()
	{
		width := DefaultWidth;
		height := DefaultHeight;
		mWindow = SDL_CreateWindow("SdlConsole".ptr,
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
			width, height, cast(u32)(SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE));
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
	mKeyUp: dg(Key, Mod);
	mKeyDown: dg(Key, Mod);


public:
	this(core: CoreSDL, win: SDL_Window*, ctx: SDL_GLContext)
	{
		w, h: int;
		SDL_GetWindowSize(win, &w, &h);
		width = cast(u32)w;
		height = cast(u32)h;

		mCore = core;
		mWindow = win;
		mContext = ctx;

		mFocusGained = StubFocusGained;
		mFocusLost = StubFocusLost;
		mMove = StubMove;
		mButton = StubButton;
		mText = StubText;
		mKeyUp = StubKeyDown;
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
	override @property fn onKeyUp(dgt: dg(Key, Mod))
	{ if (dgt is null) { mKeyUp = StubKeyUp; } else { mKeyUp = dgt; } }
	override @property fn onKeyDown(dgt: dg(Key, Mod))
	{ if (dgt is null) { mKeyDown = StubKeyDown; } else { mKeyDown = dgt; } }

	fn StubDestroy() {}
	fn StubRender() {}
	fn StubFocusGained() {}
	fn StubFocusLost() {}
	fn StubMove(int, int) {}
	fn StubButton(int) {}
	fn StubText(scope const(char)[]) {}
	fn StubKeyUp(Key, Mod) {}
	fn StubKeyDown(Key, Mod) {}
}
