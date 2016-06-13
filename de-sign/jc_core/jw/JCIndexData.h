//
//  JCIndexData.h
//  June Winter
//
//  Created by GavinLo on 14-10-15.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCIndexData__
#define __jw__JCIndexData__

#include <jw/JCBase.h>
#include <jw/JCBuffer.h>

JC_BEGIN

typedef struct
{
    JCBuffer buffer;
    unsigned long count;
    
}JCIndexData;

typedef JCIndexData* JCIndexDataRef;
typedef const JCIndexData* JCIndexDataRefC;

JCIndexData JCIndexDataMake();
void JCIndexDataFree(JCIndexDataRef data);
void JCIndexDataFreeData(JCIndexDataRef data);
void JCIndexDataBegin(JCIndexDataRef data, JCULong numIndices);
void JCIndexDataAddIndex(JCIndexDataRef data, JCUShort index);
void JCIndexDataSetIndex(JCIndexDataRef data, JCULong indexIndex, JCUShort index);
void JCIndexDataEnd(JCIndexDataRef data);
void JCIndexDataShallowCopy(JCIndexDataRef dst, JCIndexDataRefC src);

JC_END

#endif /* defined(__jw__JCIndexData__) */
