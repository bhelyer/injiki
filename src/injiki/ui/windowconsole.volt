module injiki.ui.windowconsole;

import watt.io;

import injiki.core;
import injiki.ui.console;
import injiki.ui.gl.glyph;
import injiki.ui.gl.vga;


class WindowConsole : Console
{
private:
	mRenderer: GlyphRenderer;
	mGlyphs: GlyphStore;
	mGrid: GlyphGrid;

	mCore: Core;
	mWin: Window;


public:
	this(win: Window)
	{
		mWin = win;
		mWin.onText = onText;
		mWin.onRender = onRender;
		mWin.onDestroy = onDestroy;

		initGl();
	}

	override @property fn width() i32
	{
		assert(false);
	}

	override @property fn height() i32
	{
		assert(false);
	}

	override @property fn title(s: string) bool
	{
		mWin.title = s;
		return true;
	}

	override fn refresh()
	{
		assert(false);
	}

	override fn outOfBounds(x: i32, y: i32) bool
	{
		return x < 0 || y < 0 ||
			cast(u32)x >= mGrid.numGlyphsX ||
			cast(u32)y >= mGrid.numGlyphsY;
	}

	override fn moveCursor(x: i32, y: i32)
	{
		assert(false);
	}

	override fn putc(x: i32, y: i32, fg: Console.Colour, bg: Console.Colour, c: dchar)
	{
		if (outOfBounds(x, y)) {
			return;
		}
		mGrid.put(cast(u32)x, cast(u32)y, 0, 0, cast(u8)c);
	}

	override fn puts(x: i32, y: i32, fg: Console.Colour, bg: Console.Colour, s: string)
	{
		assert(false);
	}

	override fn getch() dchar
	{
		assert(false);
	}


private:
	fn onDestroy()
	{
		if (mGlyphs !is null) {
			mGlyphs.close();
			mGlyphs = null;
		}
		if (mRenderer !is null) {
			mRenderer.close();
			mRenderer = null;
		}
	}

	fn onRender()
	{
		mGrid.render();
	}

	fn onText(str: const(char)[])
	{
		mGrid.put(0, 0, 0, 0, cast(u8)str[0]);
	}

	fn initGl()
	{
		// Needed for all other glyph parts.
		mRenderer := new GlyphRenderer();

		// Setup glyph size and store
		mGlyphs := new GlyphStore(GlyphWidth, GlyphHeight);
		foreach (index; 0u .. 256u) {
			mGlyphs.uploadVGAGlyph(cast(u8)index, cast(u16)index);
		}

		// And then setup the renderer.
		mGrid = new GlyphGrid(mRenderer, mGlyphs, 800, 600);
		counter: u8;
		foreach (y; 0 .. mGrid.numGlyphsY) {
			foreach (x; 0 .. mGrid.numGlyphsX) {
				mGrid.put(x, y, 0, 0, counter++);
			}
		}
	}
}
