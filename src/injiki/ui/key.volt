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
