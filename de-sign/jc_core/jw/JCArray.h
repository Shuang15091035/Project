//
//  JCArray.h
//  June Winter
//
//  Created by GavinLo on 14-10-17.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCArray__
#define __jw__JCArray__

#include <jw/JCBuffer.h>

JC_BEGIN

typedef struct
{
    JCULong sizeOfElement;
    JCBuffer buffer;
    
}JCArray;

JCArray JCArrayMake();
void JCArrayFree(JCArray* array);
void JCArrayInit(JCArray* array, JCULong sizeOfElement, JCULong numOfElements);
void JCArrayWrap(JCArray* array, JCULong sizeOfElement, JCBufferRefC buffer);
unsigned long JCArrayGetSize(const JCArray* array);
bool JCArrayAt(const JCArray* array, JCULong index, JCOut void* value);
bool JCArraySet(JCArray* array, JCULong index, void* value);
bool JCArrayAdd(JCArray* array, void* value);
void JCArrayClear(JCArray* array);

void JCArrayShallowCopy(JCArray* dst, const JCArray* src);

JC_END

#endif /* defined(__jw__JCArray__) */
