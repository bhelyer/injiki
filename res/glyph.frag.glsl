#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) out vec4 outColor;
layout (location = 0) in vec2 inPosition;


void main(void)
{
	outColor = vec4(1.0, 0.0, 0.0, 1.0);
}
