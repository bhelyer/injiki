module injiki.ui.components.textview;

import watt.io;
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
	x: u32;
	y: u32;
	buffer: Buffer;
	point: size_t;

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
		foreach (y; 0 .. grid.numGlyphsY) {
			foreach (x; 0 .. grid.numGlyphsX) {
				grid.put(x, y, 0, 0, ' ');
			}
		}
		buffer.seekRaw(point);
		xx := x;
		yy := y;
		while (!buffer.eof() && yy < grid.numGlyphsY) {
			c := buffer.getc();
			if (c == '\n') {
				yy++;
				xx = 0;
				continue;
			}
			grid.put(xx++, yy, 0, 0, cast(u16)c);
			if (xx >= grid.numGlyphsX) {
				// Wrap the line.
				yy++;
				xx = 0;
			}
		}
	}

	override fn onKeyDown(key: Key, mod: Mod)
	{
		fn doNothing(dchar) {}
		switch (key) with (Key) {
		case Down:
			buffer.seekRaw(point);
			buffer.getUntil('\n', doNothing);
			buffer.getc();
			if (!buffer.eof()) {
				point = buffer.point();
			}
			break;
		case Up:
			buffer.seekRaw(point);
			buffer.back();
			buffer.getBackwardsUntil('\n', doNothing);
			if (buffer.point() != 0) {
				buffer.getc();
			}
			point = buffer.point();
			break;
		default:
			break;
		}
	}
}
