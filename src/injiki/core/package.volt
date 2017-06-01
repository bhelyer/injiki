module injiki.core;

import injiki.core.sdl;
import injiki.ui.key;


abstract class Core
{
public:
	enum DefaultWidth  = 800;
	enum DefaultHeight = 600;


public:
	global fn create() Core
	{
		return new CoreSDL();
	}

	abstract fn loop() i32;

	/*!
	 * Creates a new window.
	 */
	abstract fn createWindow() Window;

	/*!
	 * Signals to the core that the application wants to shut down.
	 *
	 * Backlog of signals may be fired until finally the close signal is fired.
	 */
	abstract fn signalClose();

	/*!
	 * Close signal, fired once when Core enters the shutdown path.
	 */
	abstract @property fn onClose(dgt: dg());
}

abstract class Window
{
public:
	width, height: u32;


public:
	abstract fn fullscreen();
	abstract fn signalDestroy();

	abstract @property fn title(string);

	abstract @property fn onDestroy(dgt: dg());
	abstract @property fn onRender(dgt: dg());
	abstract @property fn onFocusGained(dgt: dg());
	abstract @property fn onFocusLost(dgt: dg());

	abstract @property fn onMove(dgt: dg(int, int));
	abstract @property fn onButton(dgt: dg(int));
	abstract @property fn onText(dgt: dg(scope const(char)[]));
	abstract @property fn onKeyUp(dgt: dg(Key, Mod));
	abstract @property fn onKeyDown(dgt: dg(Key, Mod));
}
