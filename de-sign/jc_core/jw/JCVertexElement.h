//
//  JCVertexElement.h
//  June Winter
//
//  Created by GavinLo on 14-10-15.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCVertexElement__
#define __jw__JCVertexElement__

#include <jw/JCBase.h>

JC_BEGIN

typedef enum {
    
    JCVertexElementDefaultOffset = 0xffff,
    JCVertexElementDefaultSet = 0,
    JCVertexElementMaxCount = 4,
    
}JCVertexElementConstants;

typedef enum {
    
    JCVertexSemanticUnknown = 0,
    JCVertexSemanticPosition, // 1
    JCVertexSemanticNormal, // 2
    JCVertexSemanticTangent, // 3
    JCVertexSemanticBinormal, // 4
    JCVertexSemanticTexCoord, // 5
    JCVertexSemanticColor, // 6
    JCVertexSemanticBoneWeight, // 7
    
}JCVertexSemantic;

typedef enum {
    
    JCVertexElementTypeUnknown = 0,
    JCVertexElementTypeFloat,
    JCVertexElementTypeByte,
    JCVertexElementTypeUShort,
    JCVertexElementTypeUInt,
    
    JCVertexElementTypeCount,
    
}JCVertexElementType;

typedef struct {
    
    JCUInt offset; // 数据相对于每个顶点的偏移
    JCVertexSemantic semantic; // 数据语义
    JCVertexElementType type; // 数据类型
    JCUInt count; // 多维向量（如3表示三维向量）
    JCUInt set; // 对于存在多组的语义，比如：JCVertexSemanticTexCoord、JCVertexSemanticBoneWeight等有意义
    
}JCVertexElement;

JCVertexElement JCVertexElementMake(JCUInt offset, JCVertexSemantic semantic, JCVertexElementType type, JCUInt count, JCUInt set);
JCUInt JCVertexElementGetSize(const JCVertexElement* element);
JCUInt JCVertexElementGetTypeCount(const JCVertexElement* element);

JCVertexElement JCVertexElementInvalid();
bool JCVertexElementIsValid(const JCVertexElement* element);

void JCVertexElementDeepCopy(JCVertexElement* dst, const JCVertexElement* src);

JC_END

#endif /* defined(__jw__JCVertexElement__) */
