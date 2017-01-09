#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in vec4 inData;
layout (location = 0) out vec4 gsPosition;
layout (location = 1) out vec3 gsGlyph;

uniform vec4 info;

#define stride info.z
#define glyphW info.x
#define glyphH info.y


void main(void)
{
	float quadId = float(gl_VertexID);

	// Where on the screen is this glyph in row/column.
	float x = mod(quadId, stride);
	float y = floor(quadId / stride);

	// Transform position into screen coordinate.
	// No need to matrix multiply, just offset with 1.0 or -1.0.
	x = x *  glyphW - 1.0;
	y = y * -glyphH + 1.0;

	// Pack min and max for this glyph into position.
	gsPosition = vec4(x, y, x + glyphW, y - glyphH);

	// Glyph data is formated as 4 ubytes, the first 2 is a 16bit glyph index.
	gsGlyph = vec3(inData.x * 256 + inData.y, inData.zw);
}
