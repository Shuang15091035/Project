//
//  JCGLContext.h
//  June Winter
//
//  Created by GavinLo on 14-10-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLContext__
#define __jw__JCGLContext__

#include <jw/JCBase.h>
#include <jw/jcgl.h>
#include <jw/JCRect.h>
#include <jw/JCMatrixStack.h>
#include <jw/JCMesh.h>
#include <jw/JCMaterial.h>
#include <jw/JCTexture.h>
#include <jw/JCGLCapabilities.h>
#include <jw/JCGeometryInfo.h>

JC_BEGIN

typedef enum {
    
    JCGLErrorNoError = 0,
    JCGLErrorFailed,
    JCGLErrorTextureSizeLargeThanMaxSize,
    JCGLErrorProgramLinkFailed,
    JCGLErrorShaderCompileFailed,
    JCGLErrorFrameBufferError,
    
    JCGLErrorStringLength = 2048,
    
}JCGLError;

typedef enum {
    
    JCGLWarningNone = 0,
    JCGLWarningOverMaxSamples,
    JCGLWarningGenerateMipmaps,
    
    JCGLWarningStringLength = 1024,
    
}JCGLWarning;

typedef enum
{
    JCGLMatrixModeModelView = 0,
    JCGLMatrixModeProjection,
    
    JCGLMatrixModeCount,
    
}JCGLMatrixMode;

// init
void JCGLContextInit();

// gl utils
void JCGLSetMatrixMode(JCGLMatrixMode mode);
void JCGLLoadIdentity();
bool JCGLOrthof(float left, float right, float bottom, float top, float zNear, float zFar);
bool JCGLPerspective(float fovy, float aspect, float zNear, float zFar);
JCMatrixStack* JCGLModelviewMatrixStack();
JCMatrixStack* JCGLProjectionMatrixStack();
JCMatrixStack* JCGLCurrentMatrixStack();

void JCGLSnapshot(JCRect rect, JCBitmapRef outBitmap);

JCGLCapabilities JCGLGetCapabilities();
JCGeometryInfo* JCGLGeometryInfo();

// error相关
JCGLError JCGLGetError();
void JCGLSetError(JCGLError error);
const char* JCGLGetErrorString();
void JCGLSetErrorString(const char* error);
void JCGLSetErrorStringf(const char* format, ...);
bool JCGLCheckInternalError(const char* file, int line);
int JCGLGetInternalError();
JCGLWarning JCGLGetWarning();
void JCGLSetWarning(JCGLWarning warning);
const char* JCGLGetWarningString();
void JCGLSetWarningString(const char* warning);
void JCGLSetWarningStringf(const char* format, ...);
bool JCGLCheckCurrentFramebufferStatus();

int JCGLRenderOperationEnum(JCRenderOperation operation);
GLenum JCGLGetElementGLType(JCUInt type);
GLenum JCGLGetBlendFactorEnum(JCBlendFactor factor);
GLenum JCGLGetDepthFuncEnum(JCDepthFunc func);
GLenum JCGLGetCullFaceEnum(JCCullFace cullFace);
GLint JCGLGetTextureFilterEnum(JCTextureFilter filter);
GLint JCGLGetTextureFilterEnumWithMipmap(JCTextureFilter filter, JCTextureFilter mipFilter);

// opengl扩展相关
typedef void (*JCGLRenderbufferStorageFunc)(GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
JCGLRenderbufferStorageFunc JCGLGetRenderbufferStorageFunc();
void JCGLSetRenderbufferStorageFunc(JCGLRenderbufferStorageFunc func);
void JCGLResetRenderbufferStorageFunc();
typedef void (*JCGLLogErrorFunc)(const char* error);
void JCGLSetLogErrorFunc(JCGLLogErrorFunc func);
void JCGLResetLogErrorFunc();

JC_END

#endif /* defined(__jw__JCGLContext__) */
