//
//  JCCUtils.h
//  June Winter
//
//  Created by GavinLo on 14-10-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCUtils__
#define __jw__JCUtils__

#include <string.h>
#include <ctype.h>
#include <jw/JCBase.h>

JC_BEGIN

//void* JCMemoryAlloc(size_t length, size_t sizeOfType);
void* JCMemoryAlloc(size_t capacity);
void JCMemoryFree(void* buf);
void JCMemoryClear(void* src, size_t srcOffset, size_t length, size_t sizeOfType);
void JCMemoryCopy(const void* src, size_t srcOffset, void* dst, size_t dstOffset, size_t length, size_t sizeOfType) ;
void* JCMemoryClone(void* src, size_t srcOffset, size_t length, size_t sizeOfType);
void JCArrayCopy(const void* src, size_t srcOffset, void* dst, size_t dstOffset, size_t length, size_t sizeOfType);
void JCIntArrayClear(int* src, size_t srcOffset, size_t length, int value);
float JCGetKilobytes(unsigned long bytes);
float JCGetMegabytes(unsigned long bytes);
bool JCIsWhitespace(int codePoint);

typedef struct {
    
    char info[1024];
    
}JCBaseInfo;

void JCGetBaseTypesInfo(JCBaseInfo* info);

JC_END

#endif /* defined(__jw__JCUtils__) */
