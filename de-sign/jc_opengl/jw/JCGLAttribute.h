//
//  JCGLAttribute.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLAttribute__
#define __jw__JCGLAttribute__

#include <jw/JCBase.h>
#include <jw/JCGLProgram.h>

JC_BEGIN

#define JCGLAttributeNameMaxLength 32

typedef struct
{
    char name[JCGLAttributeNameMaxLength];
    int location;
    
}JCGLAttribute;

JCGLAttribute JCGLAttributeMake();
void JCGLAttributeSetName(JCGLAttribute* attribute, const char* name);
bool JCGLAttributeSetup(JCGLAttribute* attribute, const JCGLProgram* program);

JC_END

#endif /* defined(__jw__JCGLAttribute__) */
