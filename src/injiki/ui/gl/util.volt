// Copyright © 2011-2016, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/injiki/licence.volt (BOOST ver. 1.0).
module injiki.ui.gl.util;

import watt.conv;
import watt.io.std;

import lib.gl;


fn glCheckError(file: const(char)[] = __FILE__, line: int = __LINE__)
{
	err := glGetError();
	if (!err) {
		return;
	}

	code: string;
	switch (err) {
	case GL_INVALID_ENUM: code = "GL_INVALID_ENUM"; break;
	case GL_INVALID_OPERATION: code = "GL_INVALID_OPERATION"; break;
	case GL_INVALID_VALUE: code = "GL_INVALID_VALUE"; break;
	default: code = toString(err); break;
	}

	writefln("%s:%s error: %s", file, line, code);
}
