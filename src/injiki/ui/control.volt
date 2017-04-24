module injiki.ui.control;

import watt.io;

import injiki.core;
import injiki.ui.key;
import injiki.ui.gl.glyph;
import injiki.ui.gl.vga;
import injiki.ui.components.component;


class Control
{
private:
	mRenderer: GlyphRenderer;
	mGlyphs: GlyphStore;
	mGrid: GlyphGrid;

	mCore: Core;
	mWin: Window;

	mComponents: Component[];


public:
	this(win: Window)
	{
		mWin = win;
		mWin.onText = onText;
		mWin.onRender = onRender;
		mWin.onDestroy = onDestroy;
		mWin.onKeyDown = onKeyDown;

		initGl();
	}

	fn addComponent(component: Component)
	{
		mComponents ~= component;
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
		foreach (component; mComponents) {
			component.render(mGrid);
		}
		mGrid.render();
	}

	fn onText(str: scope const(char)[])
	{
		mGrid.put(0, 0, 0, 0, cast(u8)str[0]);
	}

	fn onKeyDown(key: Key, mod: Mod)
	{
		foreach (component; mComponents) {
			component.onKeyDown(key, mod);
		}
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
		mGrid = new GlyphGrid(mRenderer, mGlyphs, mWin.width, mWin.height);
		counter: u32;
		foreach (y; 0 .. mGrid.numGlyphsY) {
			foreach (x; 0 .. mGrid.numGlyphsX) {
				mod := counter % 256u;
				modMinus := 255 - mod;
				shift := ((counter / 256u) % 3) * 8;
				bg := modMinus << shift;
				fg := mod << 16u | mod << 8u | mod;
				mGrid.put(x, y, fg, bg, mod);
				counter++;
			}
		}
	}
}
