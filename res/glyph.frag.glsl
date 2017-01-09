#version 330 core
#extension GL_ARB_explicit_attrib_location : require

in vec3 fsGlyph;
in vec2 fsUV;
layout (location = 0) out vec4 outColor;

#define glyphIndex fsGlyph.x
#define fgColor fsGlyph.y
#define bgColor fsGlyph.z


void main(void)
{
	outColor = vec4(fsUV, 0.0, 1.0);
}
