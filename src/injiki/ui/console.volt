module injiki.ui.console;

/**
 * An interface for a 2D field of coloured cells, that contain letters.
 * Traditionally implemented in a real console, ala curses, but could be
 * done in OpenGL etc just as easily.
 */
abstract class Console {
	struct Colour {
		r: u8;
		g: u8;
		b: u8;
	}

	/// Return the width of this console in characters.
	abstract @property fn width() i32;

	/// Return the height of this console in characters.
	abstract @property fn height() i32;

	/**
	 * Set the title of this console to s.
	 * This may not be possible, depending on the underlying implementation.
	 * Returns: true if the title was set, false otherwise.
	 */
	abstract @property fn title(s: string) bool;
	
	/// Refresh the display with any changes made since the last call to refresh.
	abstract fn refresh();

	/**
	 * Write the character c at position x, y (0,0 is top left)
	 * with the text the colour fg on a field of bg, or the closest
	 * approximation that the underlying implementation can display.
	 *
	 * If x or y are out of bounds, an exception must be thrown.
	 */
	abstract fn putc(x: i32, y: i32, fg: Colour, bg: Colour, c: dchar);

	/**
	 * Block until a printable character is received.
	 */
	abstract fn getch() dchar;
}