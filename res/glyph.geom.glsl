#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (points) in;
layout (location = 0) in vec4[] inPosition;
layout (location = 1) in vec3[] inGlyph;

layout (triangle_strip, max_vertices = 4) out;
layout (location = 0) out vec3 outGlyph;
layout (location = 1) out vec2 outUV;

#define minX inPosition[0].x
#define minY inPosition[0].y
#define maxX inPosition[0].z
#define maxY inPosition[0].w


void emit(vec2 pos, vec2 uv)
{
	outGlyph = inGlyph[0];
	outUV = uv;
	gl_Position = vec4(pos, 0.0, 1.0);
	EmitVertex();
}

void main(void)
{
	emit(vec2(minX, minY), vec2(0.0, 0.0));
	emit(vec2(maxX, minY), vec2(1.0, 0.0));
	emit(vec2(minX, maxY), vec2(0.0, 1.0));
	emit(vec2(maxX, maxY), vec2(1.0, 1.0));
	EndPrimitive();
}
