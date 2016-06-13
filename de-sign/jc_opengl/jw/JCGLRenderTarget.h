//
//  JCGLRenderTarget.h
//  June Winter
//
//  Created by ddeyes on 16/3/21.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLRenderTarget__
#define __jw__JCGLRenderTarget__

#include <jw/JCBase.h>
#include <jw/JCSize.h>
#include <jw/jcgl.h>

JC_BEGIN

typedef enum {
    
    JCGLRenderTargetColorFormatNone = 0,
    JCGLRenderTargetColorFormatRGBA4444 = GL_RGBA4,
    JCGLRenderTargetColorFormatRGBA5551 = GL_RGB5_A1,
    JCGLRenderTargetColorFormatRGB565 = GL_RGB565,
    JCGLRenderTargetColorFormatRGBA8888 = GL_RGBA8,
    
#if JW_OPENGL_VERSION == 2
    JCGLRenderTargetColorFormatDefault = JCGLRenderTargetColorFormatRGBA5551,
#elif JW_OPENGL_VERSION == 3
    JCGLRenderTargetColorFormatDefault = JCGLRenderTargetColorFormatRGBA8888,
#endif
    
} JCGLRenderTargetColorFormat;

typedef enum {
    
    JCGLRenderTargetDepthFormatNone = 0,
    JCGLRenderTargetDepthFormat16 = GL_DEPTH_COMPONENT16,
    JCGLRenderTargetDepthFormat24,
    JCGLRenderTargetDepthFormat32F = GL_DEPTH_COMPONENT32F,
    
    JCGLRenderTargetDepthFormatDefault = JCGLRenderTargetDepthFormat16,
    
} JCGLRenderTargetDepthFormat;

typedef enum {
    
    JCGLRenderTargetStencilFormatNone = 0,
    JCGLRenderTargetStencilFormat8,
    
    JCGLRenderTargetStencilFormatDefault = JCGLRenderTargetStencilFormatNone,
    
}JCGLRenderTargetStencilFormat;

typedef enum {
    
    JCGLRenderTargetTypeUnknown = 0,
    JCGLRenderTargetTypeBuffer,
    JCGLRenderTargetTypeTexture,
    
} JCGLRenderTargetType;

typedef struct {
    
    JCGLRenderTargetType type;
    GLsizei width;
    GLsizei height;
    GLuint frameBuffer;
    GLuint renderBuffer; // color attachment
    JCGLRenderTargetColorFormat renderFormat;
    GLuint depthBuffer; // depth attachment
    JCGLRenderTargetDepthFormat depthFormat;
    GLuint stencilBuffer;
    JCGLRenderTargetStencilFormat stencilFormat;
    GLuint textureId; // texture color attachment
    
    // MSAA
    GLsizei MSAALevel;
    GLuint resolveFrameBuffer; // for MSAA
    GLuint resolveRenderBuffer; // for MSAA
    
    GLuint glEnv;
    
}JCGLRenderTarget;

typedef JCGLRenderTarget* JCGLRenderTargetRef;
typedef const JCGLRenderTarget* JCGLRenderTargetRefC;

JCGLRenderTarget JCGLRenderTargetNull();
JCBool JCGLRenderTargetCreateBuffer(JCGLRenderTargetRef target, GLsizei width, GLsizei height, JCGLRenderTargetColorFormat colorFormat, JCGLRenderTargetDepthFormat depthFormat, JCGLRenderTargetStencilFormat stencilFormat, GLsizei MSAALevel);
JCBool JCGLRenderTargetCreateTexture(JCGLRenderTargetRef target, GLsizei width, GLsizei height, GLuint textureId, JCGLRenderTargetDepthFormat depthFormat, GLsizei MSAALevel);
void JCGLRenderTargetDelete(JCGLRenderTargetRef target);
void JCGLRenderTargetBind(JCGLRenderTargetRefC target);
void JCGLRenderTargetUnbind(JCGLRenderTargetRefC target);
bool JCGLRenderTargetBindTexture(JCGLRenderTargetRef target, GLuint textureId);
void JCGLRenderTargetPresent(JCGLRenderTargetRefC target);
bool JCGLRenderTargetIsValid(JCGLRenderTargetRefC target);
GLsizei JCGLRenderTargetGetMSAALevel(JCGLRenderTargetRefC target);
bool JCGLRenderTargetCanChangeMSAALevelTo(GLsizei MSAALevel, JCOut GLsizei* RecommendedMSAALevel);
// TODO 暂不提供
//bool JCGLRenderTargetChangeMSAALevel(JCGLRenderTargetRef target, GLsizei MSAALevel);

JC_END

#endif /* defined(__jw__JCGLRenderTarget__) */
