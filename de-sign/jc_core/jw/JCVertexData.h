//
//  JCVertexData.h
//  June Winter
//
//  Created by GavinLo on 14-10-15.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCVertexData__
#define __jw__JCVertexData__

#include <jw/JCBase.h>
#include <jw/JCVertexDeclaration.h>
#include <jw/JCBuffer.h>
#include <jw/JCVertex3.h>

JC_BEGIN

typedef struct
{
    JCVertexDeclaration declaration;
    JCBuffer buffer;
    JCULong count;
    
}JCVertexData;

typedef JCVertexData* JCVertexDataRef;
typedef const JCVertexData* JCVertexDataRefC;

JCVertexData JCVertexDataMake();
void JCVertexDataFree(JCVertexDataRef data);
void JCVertexDataFreeData(JCVertexDataRef data);
void JCVertexDataBegin(JCVertexDataRef data, JCULong numVertices);
void JCVertexDataAddVertex3(JCVertexDataRef data, JCVertex3 vertex);
void JCVertexDataSetVertex3(JCVertexDataRef data, JCULong index, JCVertex3 vertex);
void JCVertexDataEnd(JCVertexDataRef data);
void JCVertexDataShallowCopy(JCVertexDataRef dst, JCVertexDataRefC src);

JC_END

#endif /* defined(__jw__JCVertexData__) */
