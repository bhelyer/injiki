#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in vec3 fsGlyph;
layout (location = 1) in vec2 fsUV;
layout (location = 0) out vec4 outColor;

#define glyphIndex fsGlyph.x
#define fgColor fsGlyph.y
#define bgColor fsGlyph.z


void main(void)
{
	outColor = vec4(fsUV, 0.0, 1.0);
}
