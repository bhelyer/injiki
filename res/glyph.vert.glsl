#version 330 core
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_separate_shader_objects : require

layout (location = 0) in vec2 inPosition;
layout (location = 0) out vec2 outPosition;


void main(void)
{
	gl_Position = vec4(inPosition, 0.0, 1.0);
	outPosition = inPosition;
}
