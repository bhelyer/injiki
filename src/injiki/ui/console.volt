module injiki.ui.console;


/**
 * An interface for a 2D field of coloured cells, that contain letters.
 * Traditionally implemented in a real console, ala curses, but could be
 * done in OpenGL etc just as easily.
 */
interface Console
{
	struct Colour
	{
		r: u8;
		g: u8;
		b: u8;
	}

	/// Return the width of this console in characters.
	@property fn width() i32;

	/// Return the height of this console in characters.
	@property fn height() i32;

	/**
	 * Set the title of this console to s.
	 * This may not be possible, depending on the underlying implementation.
	 * Returns: true if the title was set, false otherwise.
	 */
	@property fn title(s: string) bool;

	/// Refresh the display with any changes made since the last call to refresh.
	fn refresh();

	/**
	 * Given a coordinate of (x, y) (0,0 is top left), returns if
	 * it is out of bounds.
	 * Returns: true if (x, y) is out of bounds.
	 */
	fn outOfBounds(x: i32, y: i32) bool;

	/**
	 * Set the cursor position to x, y (0,0 is top left).
	 *
	 * If x, y is out of bounds, an exception will be thrown.
	 */
	fn moveCursor(x: i32, y: i32);

	/**
	 * Write the character c at position x, y (0,0 is top left)
	 * with the text the colour fg on a field of bg, or the closest
	 * approximation that the underlying implementation can display.
	 *
	 * If x or y are out of bounds, an exception will be thrown.
	 */
	fn putc(x: i32, y: i32, fg: Colour, bg: Colour, c: dchar);

	/**
	 * Write the string s at position x, y (0,0 is top left)
	 * using 'fg' as the text colour, and 'bg' as the background colour,
	 * or the closest approximation that the underlying implementation
	 * can display.
	 *
	 * If any character of the string would be printed out of bounds,
	 * an exception will be thrown.
	 */
	fn puts(x: i32, y: i32, fg: Colour, bg: Colour, s: string);

	/**
	 * Block until a printable character is received.
	 */
	fn getch() dchar;
}
