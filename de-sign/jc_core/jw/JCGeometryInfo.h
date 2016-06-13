//
//  JCGeometryInfo.h
//  June Winter
//
//  Created by GavinLo on 15/3/9.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGeometryInfo__
#define __jw__JCGeometryInfo__

#include <jw/JCBase.h>
#include <jw/JCMesh.h>

JC_BEGIN

typedef struct {
    
    unsigned long faceCount;
    
}JCGeometryInfo;

JCGeometryInfo JCGeometryInfoMake();
void JCGeometryInfoBegin(JCGeometryInfo* info);
void JCGeometryInfoUpdate(JCGeometryInfo* info, JCRenderOperation renderOperation, const JCVertexData* vertexData, const JCIndexData* indexData);

JC_END

#endif /* defined(__jw__JCGeometryInfo__) */
