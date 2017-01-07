#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (points) in;
layout (location = 0) in vec2[] inPosition;
layout (location = 1) in vec3[] inGlyph;

layout (triangle_strip, max_vertices = 4) out;
layout (location = 0) out vec3 outGlyph;

uniform vec4 info;

#define stride info.z
#define glyphSize info.xy


void main(void)
{
	vec2 pos = inPosition[0];

	outGlyph = inGlyph[0];
	gl_Position = vec4(pos, 0.0, 1.0);
	EmitVertex();
	outGlyph = inGlyph[0];
	gl_Position = vec4(pos, 0.0, 1.0);
	EmitVertex();
	outGlyph = inGlyph[0];
	gl_Position = vec4(pos, 0.0, 1.0);
	EmitVertex();
	outGlyph = inGlyph[0];
	gl_Position = vec4(pos, 0.0, 1.0);
	EmitVertex();
	EndPrimitive();
}
