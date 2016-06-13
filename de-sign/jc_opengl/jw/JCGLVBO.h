//
//  JCGLVBO.h
//  June Winter
//
//  Created by GavinLo on 14/12/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLVBO__
#define __jw__JCGLVBO__

#include <jw/JCBase.h>
#include <jw/JCBuffer.h>
#include <jw/JCVertexData.h>
#include <jw/JCIndexData.h>

JC_BEGIN

#define JCGLVBOInvalidBufferId 0

typedef enum
{
    JCGLVBOTargetVertex,
    JCGLVBOTargetIndex,
    
}JCGLVBOTargets;

typedef struct
{
    unsigned int bufferId;
    int target;
    int usage;
    JCBuffer buffer;
    
}JCGLVBO;

JCGLVBO JCGLVBOMake(int target);
bool JCGLVBOCreate(JCGLVBO* vbo);
void JCGLVBODestroy(JCGLVBO* vbo);
bool JCGLVBOBind(const JCGLVBO* vbo);
bool JCGLVBOUnbind(const JCGLVBO* vbo);
void JCGLVBOInvalidate(JCGLVBO* vbo);

typedef struct
{
    JCGLVBO vbo;
    JCVertexData data;
    
}JCGLVertexVBO;

typedef JCGLVertexVBO* JCGLVertexVBORef;
typedef const JCGLVertexVBO* JCGLVertexVBORefC;

JCGLVertexVBO JCGLVertexVBOMake();
void JCGLVertexVBOSetData(JCGLVertexVBO* vbo, const JCVertexData* data);

/**
 * 在显存中生成VBO并且传输数据
 */
bool JCGLVertexVBOBind(JCGLVertexVBO* vbo);

void JCGLVertexVBOShallowCopy(JCGLVertexVBO* dst, const JCGLVertexVBO* src);

typedef struct
{
    JCGLVBO vbo;
    JCIndexData data;
    
}JCGLIndexVBO;

typedef JCGLIndexVBO* JCGLIndexVBORef;
typedef const JCGLIndexVBO* JCGLIndexVBORefC;

JCGLIndexVBO JCGLIndexVBOMake();
void JCGLIndexVBOSetData(JCGLIndexVBO* vbo, const JCIndexData* data);

/**
 * 在显存中生成VBO并且传输数据
 */
bool JCGLIndexVBOBind(JCGLIndexVBO* vbo);

void JCGLIndexVBOShallowCopy(JCGLIndexVBO* dst, const JCGLIndexVBO* src);

typedef enum {
    JCGLVBOUseVertex = 0x1 << 0,
    JCGLVBOUseIndex = 0x1 << 1,
    
}JCGLVBOUse;

JC_END

#endif /* defined(__jw__JCGLVBO__) */
