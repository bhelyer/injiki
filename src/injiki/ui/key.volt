module injiki.ui.key;

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
	default:            return Key.Unknown;
	}
	assert(false);
}
