// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/injiki/license.volt (BOOST ver. 1.0).
module injiki.ui.gl.glyph;

import core.exception;
import lib.gl;
import watt.io;
import injiki.ui.gl.util;
import injiki.ui.gl.shader;


/**
 * Class containing all the shared resources needed for drawing glyphs.
 */
class GlyphRenderer
{
private:
	mSampler: GLuint;
	mShader: GLuint;

public:
	this()
	{
		checkOpenGL();

		vertStr := import("glyph.vert.glsl");
		geomStr := import("glyph.geom.glsl");
		fragStr := import("glyph.frag.glsl");

		mShader = makeShaderVGF("glyph", vertStr, geomStr, fragStr);

		glGenSamplers(1, &mSampler);
		glSamplerParameteri(mSampler, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glSamplerParameteri(mSampler, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	}

	fn close()
	{
		if (mSampler != 0) {
			glDeleteSamplers(1, &mSampler);
			mSampler = 0;
		}
		if (mShader != 0) {
			glDeleteProgram(mShader);
			mShader = 0;
		}
	}


private:
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

/**
 * Class that represent one size of glyphs to be used for rendering.
 */
class GlyphStore
{
private:
	mTexture: GLuint;
	mSampler: GLuint;
	mGlyphW, mGlyphH: u32;


public:
	this(glyphW: u32, glyphH: u32)
	{
		mGlyphW = glyphW;
		mGlyphH = glyphH;

		createTexture();
	}

	fn close()
	{
		if (mTexture != 0) {
			glDeleteTextures(1, &mTexture);
			mTexture = 0;
		}
	}

	fn uploadGlyph(index: u16, data: const(u8)[])
	{
		glBindTexture(GL_TEXTURE_2D_ARRAY, mTexture);
		glTexSubImage3D(
			GL_TEXTURE_2D_ARRAY,  // GLenum target,
 			0,                    // GLint level,
			0,                    // GLint xoffset,
 			0,                    // GLint yoffset,
 			cast(GLint)index,     // GLint zoffset,
 			cast(GLsizei)mGlyphW, // GLsizei width,
 			cast(GLsizei)mGlyphH, // GLsizei height,
 			1,                    // GLsizei depth,
 			GL_RED,               // GLenum format,
 			GL_UNSIGNED_BYTE,     // GLenum type,
 			cast(const(void)*)data.ptr);
		glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
	}


private:
	fn createTexture()
	{
		// Setup vertex buffer and upload the data.
		glGenTextures(1, &mTexture);
		glBindTexture(GL_TEXTURE_2D_ARRAY, mTexture);
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
}

/**
 * A two dimensional grid of glyph ids paired with color information.
 */
class GlyphGrid
{
private:
	mRenderer: GlyphRenderer;
	mGlyphs: GlyphStore;

	mData: u32[];
	mInfo: float[4];
	mScreenW, mScreenH: u32;
	mNumGlyphs: GLsizei;


	mUniform: GLuint;
	mBuffer: GLuint;
	mVao: GLuint;


public:
	this(renderer: GlyphRenderer, glyphs: GlyphStore,
	     width: u32, height: u32)
	{
		mRenderer = renderer;
		mGlyphs = glyphs;

		// Initial creation.
		createBuffers();

		// Set a default screen size.
		setScreenSize(width, height);
	}

	fn close()
	{
		if (mUniform != 0) {
			glDeleteBuffers(1, &mUniform);
			mUniform = 0;
		}
		if (mBuffer != 0) {
			glDeleteBuffers(1, &mBuffer);
			mBuffer = 0;
		}
		if (mVao != 0) {
			glDeleteVertexArrays(1, &mVao);
			mVao = 0;
		}
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
		glUseProgram(mRenderer.mShader);
		glBindVertexArray(mVao);
		glBindSampler(0, mRenderer.mSampler);
		glBindBufferBase(GL_UNIFORM_BUFFER, 0, mUniform);
		glBindTexture(GL_TEXTURE_2D_ARRAY, mGlyphs.mTexture);
		glDrawArrays(GL_POINTS, 0, mNumGlyphs);
		glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
		glBindBufferBase(GL_UNIFORM_BUFFER, 0, 0);
		glBindSampler(0, 0);
		glBindVertexArray(0);
		glUseProgram(0);
		glCheckError();
	}


private:
	fn createBuffers()
	{
		// Setup vertex buffer and upload the data.
		glGenBuffers(1, &mBuffer);
		glGenBuffers(1, &mUniform);
		glGenVertexArrays(1, &mVao);

		// And the darkness bind them.
		glBindVertexArray(mVao);
		glBindBuffer(GL_ARRAY_BUFFER, mBuffer);

		glBufferData(GL_ARRAY_BUFFER, 256, null, GL_STATIC_DRAW);

		stride := cast(GLsizei)4;
		glVertexAttribPointer(0, 4, GL_UNSIGNED_BYTE, 0, stride, null);
		glEnableVertexAttribArray(0);

		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindVertexArray(0);
		glCheckError();


		// Setup the uniform buffer.
		glBindBuffer(GL_UNIFORM_BUFFER, mUniform);
		glBufferData(GL_UNIFORM_BUFFER, 4 * 4, null, GL_STATIC_DRAW);
		glBindBuffer(GL_UNIFORM_BUFFER, 0);
		glCheckError();
	}

	fn calculateDerivedSizes()
	{
		numGlyphsW := (mScreenW / mGlyphs.mGlyphW);
		numGlyphsH := (mScreenH / mGlyphs.mGlyphH);
		numGlyphs := cast(GLsizei)(numGlyphsW * numGlyphsH);

		updateNumGlyphs(numGlyphs);

		pixelsW := numGlyphsW * mGlyphs.mGlyphW;
		pixelsH := numGlyphsH * mGlyphs.mGlyphH;

		mInfo[0] = cast(float)mGlyphs.mGlyphW / cast(float)pixelsW * 2.f;
		mInfo[1] = cast(float)mGlyphs.mGlyphH / cast(float)pixelsH * 2.f;
		mInfo[2] = cast(float)(pixelsW / mGlyphs.mGlyphW);

		glBindBuffer(GL_UNIFORM_BUFFER, mUniform);
		glBufferSubData(GL_UNIFORM_BUFFER, 0, 4 * 4, cast(void*)mInfo.ptr);
		glBindBuffer(GL_UNIFORM_BUFFER, 0);
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

		glBindBuffer(GL_ARRAY_BUFFER, mBuffer);
		glBufferData(GL_ARRAY_BUFFER, mNumGlyphs * 4, cast(void*)mData.ptr, GL_STATIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glCheckError();
	}
}
