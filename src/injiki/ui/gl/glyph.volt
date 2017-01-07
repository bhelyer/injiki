// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/injiki/license.volt (BOOST ver. 1.0).
module injiki.ui.gl.glyph;

import lib.gl;
import watt.io;
import injiki.ui.gl.shader;


class OpenGLGlyphRenderer {
public:
	shader: GLuint;


public:
	this() {
		vertStr := import("glyph.vert.glsl");
		fragStr := import("glyph.frag.glsl");

		shader = makeShaderVF("glyph", vertStr, fragStr);
	}

	fn close() {
		if (shader != 0) {
			glDeleteProgram(shader);
			shader = 0;
		}
	}
}
