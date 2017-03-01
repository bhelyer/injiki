#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in float inGlyph;
layout (location = 1) in vec4 inFg;
layout (location = 2) in vec4 inBg;

layout (location = 0) flat out vec4  outPosition;
layout (location = 1) flat out float outGlyph;
layout (location = 2) flat out vec3  outFg;
layout (location = 3) flat out vec3  outBg;

layout (std140) uniform Uniforms {
	vec4 info;
};

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

	// Just passthrough the data.
	outFg = inFg.rgb;
	outBg = inBg.rgb;
	outGlyph = inGlyph;

	// Pack min and max for this glyph into position.
	outPosition = vec4(x, y, x + glyphW, y - glyphH);
}
