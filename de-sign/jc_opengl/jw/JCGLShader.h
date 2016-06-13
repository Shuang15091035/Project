//
//  JCGLShader.h
//  June Winter
//
//  Created by GavinLo on 14-10-17.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLShader__
#define __jw__JCGLShader__

#include <jw/JCBase.h>
#include <jw/jcgl.h>

JC_BEGIN

typedef enum {
    
    JCGLShaderInvalidShaderId = 0,
    
}JCGLShaderConstants;

typedef enum {
    
    JCGLShaderTypeVertex = GL_VERTEX_SHADER,
    JCGLShaderTypeFragment = GL_FRAGMENT_SHADER,
    
}JCGLShaderType;

typedef struct {
    
    JCUInt shaderId;
    
}JCGLShader;

typedef JCGLShader* JCGLShaderRef;
typedef const JCGLShader* JCGLShaderRefC;

JCGLShader JCGLShaderMake();
JCBool JCGLShaderCompile(JCGLShaderRef shader, JCStringRefC source, JCGLShaderType type);

JC_END

#endif /* defined(__jw__JCGLShader__) */
