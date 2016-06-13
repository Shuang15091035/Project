//
//  JCBuffer.h
//  June Winter
//
//  Created by GavinLo on 14-5-24.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCBuffer__
#define __jw__JCBuffer__

#include <jw/JCBase.h>
#include <jw/JCRef.h>
#include <jw/JCAllocator.h>

JC_BEGIN

#define JCBufferPutLast JCULongMax

/*
 * 简易的buffer封装
 * 0 <= position <= size <= capacity
 * TODO 可以考虑使用内存池进行优化,重定义分配函数
 */
typedef struct {
    
    JCByte* data;
    JCULong capacity;
    JCULong size;
    JCULong position;
    
// private
    JCAllocatorRef allocator;
    const void* _ref;
    
}JCBuffer;

typedef JCBuffer* JCBufferRef;
typedef const JCBuffer* JCBufferRefC;

JCBuffer JCBufferMake();
JCBuffer JCBufferMakeCustom(JCAllocatorRef allocator);

/**
 * 分配指定大小的buffer
 */
void JCBufferAlloc(JCBufferRef buffer, JCULong capacity);

/**
 * 释放buffer
 */
void JCBufferFree(JCBufferRef buffer);

/**
 * buffer引用，不转移释放权（引用仅表示底层内存数据的引用，size、position等均由dst，src各自控制，互不影响）
 */
bool JCBufferReference(JCBufferRef dst, JCBufferRefC src);

/**
 * buffer复制，转移释放权
 */
bool JCBufferAssign(JCBufferRef dst, JCBufferRef src);

/**
 * 是否为引用（引用没有释放权）
 */
bool JCBufferIsReference(JCBufferRefC buffer);

/*
 * data = NULL, capacity = 0, size = 0, position = 0
 */
void JCBufferReset(JCBufferRef buffer);

/*
 * 将一个data数据块（内存块）包装成buffer对象
 * @param holdData 是否由buffer管理data的生命周期
 */
JCBuffer JCBufferWrap(void* data, JCULong sizeInBytes, bool holdData);

bool JCBufferPosition(JCBufferRef buffer, JCULong newPosition);
JCByte* JCBufferGetBytes(JCBufferRefC buffer);
JCByte* JCBufferGetBytesAt(JCBufferRefC buffer, JCULong position);

/*
 * size = position
 */
void JCBufferFlush(JCBufferRef buffer);

/*
 * size = position, position = 0
 */
void JCBufferFlip(JCBufferRef buffer);

/*
 * position = 0, size = capacity
 */
void JCBufferClear(JCBufferRef buffer);

bool JCBufferPutFloat(JCBufferRef buffer, float value);
bool JCBufferPutFloatAt(JCBufferRef buffer, JCULong position, float value);
bool JCBufferPutByte(JCBufferRef buffer, JCByte value);
bool JCBufferPutByteAt(JCBufferRef buffer, JCULong position, JCByte value);
bool JCBufferPutShort(JCBufferRef buffer, JCShort value);
bool JCBufferPutShortAt(JCBufferRef buffer, JCULong position, JCShort value);
bool JCBufferPutUShort(JCBufferRef buffer, JCUShort value);
bool JCBufferPutUShortAt(JCBufferRef buffer, JCULong position, JCUShort value);
bool JCBufferPutInt(JCBufferRef buffer, JCInt value);
bool JCBufferPutIntAt(JCBufferRef buffer, JCULong position, JCInt value);
bool JCBufferPutUInt(JCBufferRef buffer, JCUInt value);
bool JCBufferPutUIntAt(JCBufferRef buffer, JCULong position, JCUInt value);

/*
 * 将(*value)写入缓冲区
 */
bool JCBufferPutValue(JCBufferRef buffer, void* value, JCULong sizeOfValue);
bool JCBufferPutValueAt(JCBufferRef buffer, JCULong position, void* value, JCULong sizeOfValue);

bool JCBufferGetFloat(JCBufferRefC buffer, JCOut float* value);
bool JCBufferGetFloatAt(JCBufferRefC buffer, JCULong position, JCOut float* value);

/*
 * 读取缓冲区内容到(*value)
 */
bool JCBufferGetValue(JCBufferRefC buffer, JCOut void* value, JCULong sizeOfValue);
bool JCBufferGetValueAt(JCBufferRefC buffer, JCULong position, JCOut void* value, JCULong sizeOfValue);

//void JCBufferShallowCopy(JCBufferRef dst, JCBufferRefC src);
//void JCBufferCopy(JCBufferRef dst, JCBufferRef src, bool holdData);

bool JCBufferIsNull(JCBufferRefC buffer);

JCAllocatorRef JCBufferDefaultAllocator();
void JCBufferSetDefaultAllocator(JCAllocatorRef allocator);
JCAllocatorInfo JCBufferDefaultAllocatorGetInfo();
    
JC_END

#endif /* defined(__jw__JCBuffer__) */
