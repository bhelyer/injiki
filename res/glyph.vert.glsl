#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in vec4 inData;
layout (location = 0) out vec2 outPosition;
layout (location = 1) out vec3 outGlyph;

uniform vec4 info;

#define stride info.z
#define glyphSize info.xy


void main(void)
{
	float quadId = float(gl_VertexID);
	float x = mod(quadId, stride);
	float y = floor(quadId / stride);

	// No need to matrix multiply, just offset with -1.0.
	outPosition = vec2(x, y) * glyphSize - vec2(1.0);

	// Glyph data is formated as 4 ubytes, the first 2 is a 16bit glyph index.
	outGlyph = vec3(inData.x * 256 + inData.y, inData.zw);
}
