//
//  JCGLProgram.h
//  June Winter
//
//  Created by GavinLo on 14-10-17.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLProgram__
#define __jw__JCGLProgram__

#include <jw/JCBase.h>
#include <jw/JCGLShader.h>

JC_BEGIN

typedef enum {
    
    JCGLProgramInvalidProgramId = -1,
    JCGLProgramInvalidLocation = -1,
    
}JCGLProgramConstants;

typedef struct {
    
    unsigned int programId;
    JCGLShader vertexShader;
    JCGLShader fragmentShader;
    
}JCGLProgram;

JCGLProgram JCGLProgramMake();
JCGLProgram JCGLProgramMakeBySource(JCStringRefC vertexShader, JCStringRefC fragmentShader);
void JCGLProgramFree(JCGLProgram* program);
bool JCGLProgramCompile(JCGLProgram* program, JCGLShader vertexShader, JCGLShader fragmentShader);
bool JCGLProgramLink(const JCGLProgram* program);
bool JCGLProgramUse(const JCGLProgram* program);
bool JCGLProgramIsValid(const JCGLProgram* program);

JC_END

#endif /* defined(__jw__JCGLProgram__) */
