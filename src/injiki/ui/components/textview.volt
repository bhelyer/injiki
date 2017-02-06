module injiki.ui.components.textview;

import watt.io;
import watt.text.ascii;
import amp.sdl2;
import injiki.text.buffer;
import injiki.ui.key;
import injiki.ui.components.component;
import injiki.ui.gl.glyph;

/**
 * Display a Buffer in a rectangle on screen.
 */
class TextView : Component
{
public:
	enum Color : u32 {
		White = 0xFF_FF_FF_FFu,
		Red   = 0xFF_00_00_FFu,
		Green = 0xFF_00_FF_00u,
		Blue  = 0xFF_FF_00_00u,
		Black = 0xFF_00_00_00u,
	}

public:
	x: u32;
	y: u32;
	buffer: Buffer;
	point: size_t;  //< Cursor location.
	screenPoint: size_t;  //< The point in the file to start drawing from.
	size_t currentLine;  //< The line the cursor is one.
	size_t screenTopLine;  //< The line the screen starts drawing from.
	size_t column;


private:
	GlyphGrid mGrid;


public:
	/**
	 * Construct a new TextView that displays buffer in a GlyphGrid.
	 * Params:
	 *   buffer = the Buffer to display.
	 *   x = the x coordinate to start rendering from.
	 *   y = the y coordinate to start rendering from.
	 */
	this(buffer: Buffer, x: u32, y: u32)
	{
		this.buffer = buffer;
		this.x = x;
		this.y = y;
	}

	override fn render(grid: GlyphGrid)
	{
		mGrid = grid;
		foreach (y; 0 .. grid.numGlyphsY) {
			foreach (x; 0 .. grid.numGlyphsX) {
				grid.put(x, y, 0, 0, ' ');
			}
		}
		buffer.seekRaw(screenPoint);
		buffer.seekRaw(buffer.beginningOfLine());
		xx := x;
		yy := y;
		while (!buffer.eof() && yy < grid.numGlyphsY) {
			glyphPoint := buffer.point();
			fg := Color.White;
			bg := Color.Black;

			if (glyphPoint == point) {
				grid.put(xx++, yy, fg, bg, '@');
			}
			c := buffer.getc();

			if (c == '\n') {
				yy++;
				xx = 0;
				continue;
			}
			if (glyphPoint != point) {
				grid.put(xx++, yy, fg, bg, cast(u16)c);
			}
			if (xx >= grid.numGlyphsX) {
				// Wrap the line.
				yy++;
				xx = 0;
			}
		}
	}

	override fn onKeyDown(key: Key, mod: Mod)
	{
		switch (key) with (Key) {
		case Down:
			cursorDown();
			break;
		case Up:
			cursorUp();
			break;
		case Left:
			cursorLeft();
			break;
		case Right:
			cursorRight();
			break;
		case Unknown, PageDown, PageUp:
			break;
		default:
			c := cast(dchar)key;
			if (c == 's' && mod & Mod.Control) {
				buffer.saveFile();
				break;
			} else if (mod & Mod.Shift) {
				c = toUpper(c);
			}
			buffer.seekRaw(point);
			buffer.ins(c);
			buffer.getc();
			point = buffer.point();
			break;
		}
	}

private:

	/// Move a point to the next line, increment a line count.
	fn nextLine(ref p: size_t, ref lineCount: size_t)
	{
		fn doNothing(dchar) {}
		buffer.seekRaw(p);
		buffer.getUntil('\n', doNothing);
		buffer.getc();
		newColumn: size_t = 0;
		while (!buffer.eof() && newColumn <= column && buffer.rc() != '\n') {
			buffer.getc();
			newColumn++;
		}
		column = newColumn > 0 ? newColumn - 1 : newColumn;
		if (!buffer.eof()) {
			lineCount++;
			p = buffer.point();
		}
	}

	/// Move a point to the previous line, decrement a line count.
	fn previousLine(ref p: size_t, ref lineCount: size_t)
	{
		fn doNothing(dchar) {}
		buffer.seekRaw(p);
		if (buffer.rc() != '\n') {
			buffer.getBackwardsUntil('\n', doNothing);
		} else {
			buffer.back();
		}
		buffer.getBackwardsUntil('\n', doNothing);
		if (buffer.point() != 0) {
			buffer.getc();
		}
		newColumn: size_t = 0;
		while (!buffer.eof() && newColumn <= column && buffer.rc() != '\n') {
			buffer.getc();
			newColumn++;
		}
		column = newColumn > 0 ? newColumn - 1 : newColumn;
		p = buffer.point();
		if (lineCount > 0) {
			lineCount--;
		}
	}

	fn cursorDown()
	{
		nextLine(ref point, ref currentLine);
		if (currentLine - screenTopLine >= mGrid.numGlyphsY) {
			nextLine(ref screenPoint, ref screenTopLine);
		}
	}

	fn cursorUp()
	{
		previousLine(ref point, ref currentLine);
		if (currentLine < screenTopLine) {
			previousLine(ref screenPoint, ref screenTopLine);
		}
	}

	fn cursorRight()
	{
		buffer.seekRaw(point);
		if (!buffer.eof()) {
			column++;
			c := buffer.getc();
			if (c == '\n') {
				cursorDown();
				return;
			}
			point = buffer.point();
		}
	}

	fn cursorLeft()
	{
		if (point > 0) {
			column--;
			buffer.seekRaw(point);
			buffer.back();
			if (buffer.rc() == '\n') {
				cursorUp();
				return;
			}
			point = buffer.point();
		}
	}
}
