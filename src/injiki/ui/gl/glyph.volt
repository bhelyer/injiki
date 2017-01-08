// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/injiki/license.volt (BOOST ver. 1.0).
module injiki.ui.gl.glyph;

import core.exception;
import lib.gl;
import watt.io;
import injiki.ui.gl.util;
import injiki.ui.gl.shader;


class OpenGLGlyphRenderer {
public:
	shader: GLuint;
	buf: GLuint;
	vao: GLuint;
	info: float[4];

	numGlyphs: GLsizei;
	glyphW, glyphH: uint;
	screenW, screenH: uint;


public:
	this() {
		checkOpenGL();

		vertStr := import("glyph.vert.glsl");
		geomStr := import("glyph.geom.glsl");
		fragStr := import("glyph.frag.glsl");

		shader = makeShaderVGF("glyph", vertStr, geomStr, fragStr);

		// Create buffers.
		createBuffers();

		// Default font size, we don't use the setGlyphSize function
		// since the screen size has not yet been set.
		glyphW = 8; glyphH = 10;

		// Set a default screen size.
		setScreenSize(800, 600);
	}

	fn close() {
		if (shader != 0) {
			glDeleteProgram(shader);
			shader = 0;
		}
		if (buf != 0) {
			glDeleteBuffers(1, &buf);
			buf = 0;
		}
		if (vao != 0) {
			glDeleteVertexArrays(1, &vao);
			vao = 0;
		}
	}

	fn setScreenSize(screenW: uint, screenH: uint) {
		this.screenW = screenW;
		this.screenH = screenH;

		calculateDerivedSizes();
	}

	fn setGlyphSize(glyphW: uint, glyphH: uint) {
		this.glyphW = glyphW;
		this.glyphH = glyphH;

		calculateDerivedSizes();
	}

	fn render() {
		glBindVertexArray(vao);
		glUseProgram(shader);
		glDrawArrays(GL_POINTS, 0, numGlyphs);
		glUseProgram(0);
		glBindVertexArray(0);
		glCheckError();
	}


private:
	fn createBuffers() {
		// Setup vertex buffer and upload the data.
		glGenBuffers(1, &buf);
		glGenVertexArrays(1, &vao);

		// And the darkness bind them.
		glBindVertexArray(vao);
		glBindBuffer(GL_ARRAY_BUFFER, buf);

		glBufferData(GL_ARRAY_BUFFER, 256, null, GL_STATIC_DRAW);

		stride := cast(GLsizei)4;
		glVertexAttribPointer(0, 4, GL_UNSIGNED_BYTE, 0, stride, null);
		glEnableVertexAttribArray(0);

		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindVertexArray(0);
		glCheckError();
	}

	fn calculateDerivedSizes() {
		numGlyphsW := (screenW / glyphW);
		numGlyphsH := (screenH / glyphH);
		numGlyphs = cast(GLsizei)(numGlyphsW * numGlyphsH);

		pixelsW := numGlyphsW * glyphW;
		pixelsH := numGlyphsH * glyphH;

		info[0] = cast(float)glyphW / cast(float)pixelsW * 2.f;
		info[1] = cast(float)glyphH / cast(float)pixelsH * 2.f;
		info[2] = cast(float)(pixelsW / glyphW);

		glUseProgram(shader);
		loc := glGetUniformLocation(shader, "info");
		glUniform4fv(loc, 1, info.ptr);
		glUseProgram(0);
		glCheckError();

		glBindBuffer(GL_ARRAY_BUFFER, buf);
		glBufferData(GL_ARRAY_BUFFER, numGlyphs * 4, null, GL_STATIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glCheckError();
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
