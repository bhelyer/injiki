#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in vec3 inGlyph;
layout (location = 1) in vec2 inUV;
layout (location = 0) out vec4 outColor;

uniform sampler2DArray tex;

#define glyphIndex inGlyph.x
#define fgColor inGlyph.y
#define bgColor inGlyph.z


void main(void)
{
	float a = texture(tex, vec3(inUV, glyphIndex)).r;
	outColor = vec4(vec3(a), 1.0);
}
