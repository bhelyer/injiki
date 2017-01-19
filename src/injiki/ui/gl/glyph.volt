// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/injiki/license.volt (BOOST ver. 1.0).
module injiki.ui.gl.glyph;

import core.exception;
import lib.gl;
import watt.io;
import injiki.ui.gl.util;
import injiki.ui.gl.timer;
import injiki.ui.gl.shader;


class OpenGLGlyphRenderer
{
public:
	shader: GLuint;
	sampler: GLuint;
	tex: GLuint;
	buf: GLuint;
	vao: GLuint;
	info: float[4];

	timer: Timer;


private:
	mData: u32[];
	mNumGlyphs: GLsizei;
	mGlyphW, mGlyphH: u32;
	mScreenW, mScreenH: u32;


public:
	this(glyphW: u32, glyphH: u32)
	{
		checkOpenGL();
		timer.setup();

		mGlyphW = glyphW;
		mGlyphH = glyphH;

		vertStr := import("glyph.vert.glsl");
		geomStr := import("glyph.geom.glsl");
		fragStr := import("glyph.frag.glsl");

		shader = makeShaderVGF("glyph", vertStr, geomStr, fragStr);

		// Initial creation.
		createTexture();
		createBuffers();

		// Set a default screen size.
		setScreenSize(800, 600);
	}

	fn close()
	{
		if (shader != 0) {
			glDeleteProgram(shader);
			shader = 0;
		}
		if (tex != 0) {
			glDeleteTextures(1, &tex);
			tex = 0;
		}
		if (buf != 0) {
			glDeleteBuffers(1, &buf);
			buf = 0;
		}
		if (vao != 0) {
			glDeleteVertexArrays(1, &vao);
			vao = 0;
		}
		timer.close();
	}

	fn uploadGlyph(index: u16, data: const(u8)[])
	{
		glBindTexture(GL_TEXTURE_2D_ARRAY, tex);
		glTexSubImage3D(
			GL_TEXTURE_2D_ARRAY,  // GLenum target,
 			0,                    // GLint level,
			0,                    // GLint xoffset,
 			0,                    // GLint yoffset,
 			cast(GLint)index,     // GLint zoffset,
 			cast(GLsizei)mGlyphW, //GLsizei width,
 			cast(GLsizei)mGlyphH, //GLsizei height,
 			1,                    //GLsizei depth,
 			GL_RED,               //GLenum format,
 			GL_UNSIGNED_BYTE,     //GLenum type,
 			cast(const(void)*)data.ptr);
		glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
	}

	fn setScreenSize(screenW: uint, screenH: uint)
	{
		if (mScreenW == screenW &&
		    mScreenH == screenH) {
			return;
		}

		mScreenW = screenW;
		mScreenH = screenH;

		calculateDerivedSizes();
	}

	fn render()
	{
		glUseProgram(shader);
		glBindVertexArray(vao);
		glBindSampler(0, sampler);
		glBindTexture(GL_TEXTURE_2D_ARRAY, tex);
		glDrawArrays(GL_POINTS, 0, mNumGlyphs);
		glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
		glBindSampler(0, 0);
		glBindVertexArray(0);
		glUseProgram(0);
		glCheckError();
	}


private:
	fn createTexture()
	{
		glGenSamplers(1, &sampler);
		glSamplerParameteri(sampler, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glSamplerParameteri(sampler, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

		// Setup vertex buffer and upload the data.
		glGenTextures(1, &tex);
		glBindTexture(GL_TEXTURE_2D_ARRAY, tex);
		glTexImage3D(
			GL_TEXTURE_2D_ARRAY,  // GLenum target,
 			0,                    // GLint level,
 			GL_R8,                // GLint internalFormat,
 			cast(GLsizei)mGlyphW, // GLsizei width,
 			cast(GLsizei)mGlyphH, // GLsizei height,
 			256,                  // GLsizei depth,
 			0,                    // GLint border,
 			GL_RED,               // GLenum format,
 			GL_UNSIGNED_BYTE,     // GLenum type,
 			null);
		glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
	}

	fn createBuffers()
	{
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

	fn calculateDerivedSizes()
	{
		numGlyphsW := (mScreenW / mGlyphW);
		numGlyphsH := (mScreenH / mGlyphH);
		numGlyphs := cast(GLsizei)(numGlyphsW * numGlyphsH);

		updateNumGlyphs(numGlyphs);

		pixelsW := numGlyphsW * mGlyphW;
		pixelsH := numGlyphsH * mGlyphH;

		info[0] = cast(float)mGlyphW / cast(float)pixelsW * 2.f;
		info[1] = cast(float)mGlyphH / cast(float)pixelsH * 2.f;
		info[2] = cast(float)(pixelsW / mGlyphW);

		glUseProgram(shader);
		loc := glGetUniformLocation(shader, "info");
		glUniform4fv(loc, 1, info.ptr);
		glUseProgram(0);
		glCheckError();
	}

	fn updateNumGlyphs(numGlyphs: GLsizei)
	{
		if (mNumGlyphs == numGlyphs) {
			return;
		}

		// Update the host store.
		mNumGlyphs = numGlyphs;
		mData = new u32[](mNumGlyphs);

		// Temporary hack with initial data.
		foreach (i, ref d; mData) {
			d = cast(u32)i;
		}

		glBindBuffer(GL_ARRAY_BUFFER, buf);
		glBufferData(GL_ARRAY_BUFFER, mNumGlyphs * 4, cast(void*)mData.ptr, GL_STATIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glCheckError();
	}

	static fn checkOpenGL()
	{
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

fn failedVersion(ver: string) Exception
{
	str := new string("Requires OpenGL ", ver);
	error.writefln(str);
	return new Exception(str);
}

fn failedExtension(ext: string) Exception
{
	str := new string("Requires ", ext, " extension");
	error.writefln(str);
	return new Exception(str);
}
