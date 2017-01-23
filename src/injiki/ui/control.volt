module injiki.ui.control;

import watt.io;

import injiki.core;
import injiki.ui.gl.glyph;
import injiki.ui.gl.vga;


class Control
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


private:
	fn outOfBounds(x: i32, y: i32) bool
	{
		return x < 0 || y < 0 ||
			cast(u32)x >= mGrid.numGlyphsX ||
			cast(u32)y >= mGrid.numGlyphsY;
	}

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
