// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/injiki/license.volt (BOOST ver. 1.0).
module injiki.ui.gl.glyph;

import core.exception;
import lib.gl;
import watt.io;
import injiki.ui.gl.shader;


class OpenGLGlyphRenderer {
public:
	shader: GLuint;


public:
	this() {
		checkOpenGL();

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

	static fn checkOpenGL() {
		if (!GL_VERSION_3_3) {
			throw failedVersion("3.3");
		}
		if (!GL_ARB_explicit_attrib_location) {
			throw failedExtension("GL_ARB_explicit_attrib_location");
		}
		if (!GL_ARB_separate_shader_objects) {
			throw failedExtension("GL_ARB_separate_shader_objects");
		}
	}
}

fn failedVersion(ver: string) Exception {
	str := new string("Requires OpenGL ", ver);
	error.writefln(str);
	return new Exception(str);
}

fn failedExtension(ext: string) Exception {
	str := new string("Requires ", ext, " extension");
	error.writefln(str);
	return new Exception(str);
}
