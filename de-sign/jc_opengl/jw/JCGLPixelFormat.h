//
//  JCGLPixelFormat.h
//  June Winter
//
//  Created by GavinLo on 14/12/8.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLPixelFormat__
#define __jw__JCGLPixelFormat__

#include <jw/JCPixelFormat.h>
#include <jw/JCGL.h>

JC_BEGIN

typedef struct {
    
    GLint internalformat;
    GLenum format;
    GLenum type;
    
}JCGLImageParameters;

JCGLImageParameters JCGLImageParametersMake(GLint internalformat, GLenum format, GLenum type);
bool JCGLImageParametersIsInvalid(const JCGLImageParameters* ip);

bool JCPixelFormatIsCompressed(JCPixelFormat format);
JCGLImageParameters JCPixelFormatToGLImageParameters(JCPixelFormat format);

// 废弃
GLenum JCPixelFormatToGLFormat(JCPixelFormat format);
GLenum JCPixelFormatToGLDataType(JCPixelFormat format);

JC_END

#endif /* defined(__jw__JCGLPixelFormat__) */
