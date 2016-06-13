//
//  jcgl.h
//  June Winter
//
//  Created by GavinLo on 15/1/27.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__jcgl__
#define __jw__jcgl__

#include <stdlib.h>
#include <stdio.h>
#include <jw/JCBase.h>

// OpenGL ES documents https://www.khronos.org/opengles/sdk/docs/

#ifndef JW_OPENGL_VERSION
#define JW_OPENGL_VERSION 3
#endif

#if JW_OPENGL_VERSION == 2
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#elif JW_OPENGL_VERSION == 3
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#endif

// GL_RGBA8
#ifndef GL_RGBA8
#define GL_RGBA8 GL_RGBA8_OES
#endif
// GL_HALF_FLOAT
#ifndef GL_HALF_FLOAT
#define GL_HALF_FLOAT GL_HALF_FLOAT_OES
#endif
// GL_MAX_SAMPLES
#ifndef GL_MAX_SAMPLES
#define GL_MAX_SAMPLES GL_MAX_SAMPLES_APPLE
#endif
// GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE
#ifndef GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE
#define GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_APPLE
#endif
// GL_DRAW_FRAMEBUFFER
#ifndef GL_DRAW_FRAMEBUFFER
#define GL_DRAW_FRAMEBUFFER GL_DRAW_FRAMEBUFFER_APPLE
#endif
// GL_READ_FRAMEBUFFER
#ifndef GL_READ_FRAMEBUFFER
#define GL_READ_FRAMEBUFFER GL_READ_FRAMEBUFFER_APPLE
#endif
// GL_TEXTURE_MAX_LEVEL
#ifndef GL_TEXTURE_MAX_LEVEL
#define GL_TEXTURE_MAX_LEVEL GL_TEXTURE_MAX_LEVEL_APPLE
#endif

// JCGLRenderbufferStorageMultisample
#ifndef JCGLRenderbufferStorageMultisample
#if JW_OPENGL_VERSION == 2
#define JCGLRenderbufferStorageMultisample glRenderbufferStorageMultisampleAPPLE
#elif JW_OPENGL_VERSION == 3
#define JCGLRenderbufferStorageMultisample glRenderbufferStorageMultisample
#endif
#endif
// JCGLResolveMultisampleFramebuffer
#ifndef JCGLResolveMultisampleFramebuffer
#if JW_OPENGL_VERSION == 2
#define JCGLResolveMultisampleFramebuffer(width, height, mask, filter) glResolveMultisampleFramebufferAPPLE()
#elif JW_OPENGL_VERSION == 3
#define JCGLResolveMultisampleFramebuffer(width, height, mask, filter) glBlitFramebuffer(0, 0, width, height, 0, 0, width, height, mask, filter)
#endif
#endif
// JCGLDiscardFramebuffer
#ifndef JCGLDiscardFramebuffer
#if JW_OPENGL_VERSION == 2
#define JCGLDiscardFramebuffer glDiscardFramebufferEXT
#elif JW_OPENGL_VERSION == 3
#define JCGLDiscardFramebuffer glInvalidateFramebuffer
#endif
#endif

JC_BEGIN

void JCGLInit();
GLuint JCGLGenEnv();
void JCGLDeleteEnv(GLuint env);
void JCGLBindEnv(GLuint env);
void JCGLResetEnv();
void JCGLClearColor(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void JCGLClear(GLbitfield mask);
void JCGLEnable(GLenum cap);
void JCGLDisable(GLenum cap);
void JCGLDepthMask(GLboolean flag);
void JCGLDepthFunc(GLenum func);
void JCGLCullFace(GLenum mode);
void JCGLBindFramebuffer(GLenum target, GLuint framebuffer);
void JCGLBindBuffer(GLenum target, GLuint buffer);
void JCGLBindTexture(GLenum target, GLuint texture);
void JCGLActiveTexture(GLenum texture);
void JCGLDrawArrays(GLenum mode, GLint first, GLsizei count);
void JCGLDrawElements(GLenum mode, GLsizei count, GLenum type, const GLvoid* indices);

void JCGLUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, const JCFloat* value);
void JCGLUniformMatrix3fv(GLint location, GLsizei count, GLboolean transpose, const JCFloat* value);

JC_END

#endif /* defined(__jw__jcgl__) */
