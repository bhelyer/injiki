// Copyright © 2011-2016, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/injiki/license.volt (BOOST ver. 1.0).
module injiki.ui.gl.shader;

import lib.gl;
import watt.io;


fn makeShaderVF(name: string, vert: string, frag: string) GLuint {
	// Compile the shaders
	shader := createAndCompileShaderVF(name, vert, frag);

	// Linking the Shader Program
	glLinkProgram(shader);

	// Check status and print any debug message.
	if (!printDebug(name, shader, true, "program (vert/frag)")) {
		glDeleteProgram(shader);
		return 0;
	}

	return shader;
}

fn createAndCompileShaderVF(name: string, vert: string, frag: string) GLuint {
	assert(vert.length > 0 && frag.length > 0);

	// Create the handels
	vertShader := glCreateShader(GL_VERTEX_SHADER);
	fragShader := glCreateShader(GL_FRAGMENT_SHADER);
	programShader := glCreateProgram();

	// Attach the shaders to a program handel.
	glAttachShader(programShader, vertShader);
	glAttachShader(programShader, fragShader);

	// Load and compile the Vertex Shader
	compileShader(name, vertShader, vert, "vert");

	// Load and compile the Fragment Shader
	compileShader(name, fragShader, frag, "frag");

	// The shader objects are not needed any more,
	// the programShader is the complete shader to be used.
	glDeleteShader(vertShader);
	glDeleteShader(fragShader);

	return programShader;
}

fn compileShader(name: string, shader: GLuint, source: string, type: string) {
	ptr: const(char)*;
	length: int;

	ptr = source.ptr;
	length = cast(int)source.length - 1;
	glShaderSource(shader, 1, &ptr, &length);
	glCompileShader(shader);

	// Print any debug message
	printDebug(name, shader, false, type);
}

fn printDebug(name: string, shader: GLuint, program: bool, type: string) bool {
	// Instead of pointers, realy bothersome.
	status: GLint;
	length: GLint;

	// Get information about the log on this object.
	if (program) {
		glGetProgramiv(shader, GL_LINK_STATUS, &status);
		glGetProgramiv(shader, GL_INFO_LOG_LENGTH, &length);
	} else {
		glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
		glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &length);
	}

	buffer: char[];
	if (length > 2) {
		// Yes length+1 and just length.
		buffer = new char[](length + 1);
		buffer.ptr[length] = 0;

		if (program) {
			glGetProgramInfoLog(shader, length, &length, buffer.ptr);
		} else {
			glGetShaderInfoLog(shader, length, &length, buffer.ptr);
		}
	} else {
		length = 0;
	}

	switch (status) {
	case 1: //GL_TRUE:
		// Only print warnings from the linking stage.
		if (length != 0 && program) {
			writef("%s \"%s\" status ok!\n%s", type, name, buffer);
		} else if (program) {
			writefln("%s \"%s\" status ok!", type, name);
		}

		return true;

	case 0: //GL_FALSE:
		if (length != 0) {
			writef("%s \"%s\" status ERROR!\n%s", type, name, buffer);
		} else if (program) {
			writefln("%s \"%s\" status ERROR!", type, name);
		}

		return false;

	default:
		if (length != 0) {
			writef("%s \"%s\" status #%s\n%s", type, name, status, buffer);
		} else if (program) {
			writefln("%s \"%s\" status #%s", type, name, status);
		}

		return false;
	}
}
