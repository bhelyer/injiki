module injiki.ui.components.component;

import injiki.ui.key;
import injiki.ui.gl.glyph;

/**
 * An interface for objects that draw a useful thing to a GlyphGrid.
 */
interface Component
{
	/**
	 * Draw your useful thing to grid.
	 */
	fn render(grid: GlyphGrid);

	/**
	 * Received when a key is pressed.
	 */
	fn onKeyDown(key: Key, mod: Mod);
}
