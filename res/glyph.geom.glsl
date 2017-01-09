#version 330 core

layout (points) in;
in vec4[] gsPosition;
in vec3[] gsGlyph;

layout (triangle_strip, max_vertices = 4) out;
out vec3 fsGlyph;
out vec2 fsUV;

#define minX gsPosition[0].x
#define minY gsPosition[0].y
#define maxX gsPosition[0].z
#define maxY gsPosition[0].w


void emit(vec2 pos, vec2 uv)
{
	fsGlyph = gsGlyph[0];
	fsUV = uv;
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
