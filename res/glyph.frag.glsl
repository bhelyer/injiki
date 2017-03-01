#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in float inGlyph;
layout (location = 1) in vec2 inUV;
layout (location = 2) in vec3 inFg;
layout (location = 3) in vec3 inBg;
layout (location = 0) out vec4 outColor;

uniform sampler2DArray texGlyphs;


void main(void)
{
	float a = texture(texGlyphs, vec3(inUV, inGlyph)).r;
	outColor = vec4(mix(inBg, inFg, a), 1.0);
}
