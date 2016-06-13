//
//  JCGLUniform.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLUniform__
#define __jw__JCGLUniform__

#include <jw/JCBase.h>
#include <jw/JCGLProgram.h>
#include <jw/JCVector2.h>
#include <jw/JCVector3.h>
#include <jw/JCVector4.h>
#include <jw/JCMatrix3.h>
#include <jw/JCMatrix4.h>
#include <jw/JCColor.h>

JC_BEGIN

#define JCGLUniformNameMaxLength 32

typedef struct
{
    char name[JCGLUniformNameMaxLength];
    int location;
    
}JCGLUniform;

JCGLUniform JCGLUniformMake();
void JCGLUniformSetName(JCGLUniform* uniform, const char* name);
bool JCGLUniformSetup(JCGLUniform* uniform, const JCGLProgram* program);
bool JCGLUniformSetVector2(const JCGLUniform* uniform, JCVector2 vector);
bool JCGLUniformSetVector3(const JCGLUniform* uniform, JCVector3 vector);
bool JCGLUniformSetVector4(const JCGLUniform* uniform, JCVector4 vector);
bool JCGLUniformSetColor(const JCGLUniform* uniform, JCColor color);
bool JCGLUniformSetMatrix4(const JCGLUniform* uniform, JCMatrix4 matrix);
bool JCGLUniformSetMatrix4Array(const JCGLUniform* uniform, const JCFloat* array, JCULong count);
bool JCGLUniformSetMatrix3(const JCGLUniform* uniform, JCMatrix3 matrix);
bool JCGLUniformSetInteger(const JCGLUniform* uniform, int i);
bool JCGLUniformSetFloat(const JCGLUniform* uniform, float f);
bool JCGLUniformSetBool(const JCGLUniform* uniform, bool b);

JC_END

#endif /* defined(__jw__JCGLUniform__) */
