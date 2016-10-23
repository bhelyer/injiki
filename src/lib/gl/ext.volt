module lib.gl.ext;


private import lib.gl.types;
private import lib.gl.enums;
private import lib.gl.funcs;
global bool GL_ARB_explicit_attrib_location;
global bool GL_KHR_debug;
extern(System) @loadDynamic {
void glDebugMessageControl(GLenum, GLenum, GLenum, GLsizei, const(GLuint)*, GLboolean);
void glDebugMessageInsert(GLenum, GLenum, GLuint, GLenum, GLsizei, const(GLchar)*);
void glDebugMessageCallback(GLDEBUGPROC, const(void)*);
GLuint glGetDebugMessageLog(GLuint, GLsizei, GLenum*, GLenum*, GLuint*, GLenum*, GLsizei*, GLchar*);
void glPushDebugGroup(GLenum, GLuint, GLsizei, const(GLchar)*);
void glPopDebugGroup();
void glObjectLabel(GLenum, GLuint, GLsizei, const(GLchar)*);
void glGetObjectLabel(GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
void glObjectPtrLabel(const(void)*, GLsizei, const(GLchar)*);
void glGetObjectPtrLabel(const(void)*, GLsizei, GLsizei*, GLchar*);
void glDebugMessageControlKHR(GLenum, GLenum, GLenum, GLsizei, const(GLuint)*, GLboolean);
void glDebugMessageInsertKHR(GLenum, GLenum, GLuint, GLenum, GLsizei, const(GLchar)*);
void glDebugMessageCallbackKHR(GLDEBUGPROCKHR, const(void)*);
GLuint glGetDebugMessageLogKHR(GLuint, GLsizei, GLenum*, GLenum*, GLuint*, GLenum*, GLsizei*, GLchar*);
void glPushDebugGroupKHR(GLenum, GLuint, GLsizei, const(GLchar)*);
void glPopDebugGroupKHR();
void glObjectLabelKHR(GLenum, GLuint, GLsizei, const(GLchar)*);
void glGetObjectLabelKHR(GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
void glObjectPtrLabelKHR(const(void)*, GLsizei, const(GLchar)*);
void glGetObjectPtrLabelKHR(const(void)*, GLsizei, GLsizei*, GLchar*);
void glGetPointervKHR(GLenum, void**);
}
