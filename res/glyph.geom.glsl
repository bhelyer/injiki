#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (points) in;
layout (location = 0) in  vec4[] inPosition;
layout (location = 1) in float[] inGlyph;
layout (location = 2) in  vec3[] inFg;
layout (location = 3) in  vec3[] inBg;

layout (triangle_strip, max_vertices = 4) out;
layout (location = 0) flat out float outGlyph;
layout (location = 1)      out  vec2 outUV;
layout (location = 2) flat out  vec3 outFg;
layout (location = 3) flat out  vec3 outBg;
out gl_PerVertex
{
	vec4 gl_Position;
};

#define minX inPosition[0].x
#define minY inPosition[0].y
#define maxX inPosition[0].z
#define maxY inPosition[0].w


void emit(vec2 pos, vec2 uv)
{
	outGlyph = inGlyph[0];
	outUV = uv;
	outFg = inFg[0];
	outBg = inBg[0];
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
