#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in vec3 inGlyph;
layout (location = 1) in vec2 inUV;
layout (location = 0) out vec4 outColor;

#define glyphIndex inGlyph.x
#define fgColor inGlyph.y
#define bgColor inGlyph.z


void main(void)
{
	outColor = vec4(inUV, 0.0, 1.0);
}
