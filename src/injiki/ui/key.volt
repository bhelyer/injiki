module injiki.ui.key;

import watt.text.ascii;
import amp.sdl2;

enum Key
{
	Unknown,
	PageDown,
	PageUp,
	Up,
	Down,
	Left,
	Right,
}

enum Mod : u16
{
	None,
	LeftShift = KMOD_LSHIFT,
	RightShift = KMOD_RSHIFT,
	LeftControl = KMOD_LCTRL,
	RightControl = KMOD_RCTRL,
	LeftAlt = KMOD_LALT,
	RightAlt = KMOD_RALT,
	LeftGui = KMOD_LGUI,
	RightGui = KMOD_RGUI,
	Numlock = KMOD_NUM,
	Capslock = KMOD_CAPS,
	AltGr = KMOD_MODE,
	Control = KMOD_CTRL,
	Shift = KMOD_SHIFT,
	Alt = KMOD_ALT,
	Gui = KMOD_GUI
}

fn isPrintable(sdlkc: SDL_Keycode) bool
{
	c := cast(dchar)sdlkc;
	switch (c) {
	// Letters
	case 'a', 'b', 'c', 'd', 'e', 'f', 'g',
	'h', 'i', 'j', 'k', 'l', 'm', 'n',
	'o', 'p', 'q', 'r', 's', 't', 'u',
	'v', 'w', 'x', 'y', 'z',
	// Numbers
	'1', '2', '3', '4', '5', '6', '7',
	'8', '9', '0',
	// Symbols
	' ', '\'', ';', '.', '"':
		return true;
	default:
		return false;
	}
}

/// Translate an SDL_Keycode to an Injiki Key enum value.
fn translateKey(sdlkc: SDL_Keycode) Key
{
	switch (sdlkc) {
	case SDLK_PAGEDOWN: return Key.PageDown;
	case SDLK_PAGEUP:   return Key.PageUp;
	case SDLK_UP:       return Key.Up;
	case SDLK_DOWN:     return Key.Down;
	case SDLK_LEFT:     return Key.Left;
	case SDLK_RIGHT:    return Key.Right;
	default:
		if (isPrintable(sdlkc)) {
			c := cast(dchar)sdlkc;
			return cast(Key)sdlkc;
		} else {
			return Key.Unknown;
		}
	}
	assert(false);
}
