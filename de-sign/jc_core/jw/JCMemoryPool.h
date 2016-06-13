//
//  JCMemoryPool.h
//  June Winter
//
//  Created by ddeyes on 16/1/27.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef JCMemoryPool_h
#define JCMemoryPool_h

#include <jw/JCBase.h>
#include <jw/JCAllocator.h>

JC_BEGIN

/**
 * 伙伴算法分配器
 * TODO 线程安全
 */

// JCBuddyChunk
struct JCBuddyChunk;
typedef struct JCBuddyChunk* JCBuddyChunkRef;
typedef const struct JCBuddyChunk* JCBuddyChunkRefC;

JCBuddyChunkRef JCBuddyChunkNew(JCULong size, JCULong unit);
void JCBuddyChunkDelete(JCBuddyChunkRef chunk);
void* JCBuddyChunkAlloc(JCBuddyChunkRef chunk, JCULong capacity);
bool JCBuddyChunkFree(JCBuddyChunkRef chunk, void* buf);
bool JCBuddyChunkIsEmpty(JCBuddyChunkRefC chunk);
JCAllocatorInfo JCBuddyChunkGetInfo(JCBuddyChunkRefC chunk);
//const char* JCBuddyChunkDump(JCBuddyChunkRefC chunk);

// JCBuddyAllocator
struct JCBuddyAllocator;
typedef struct JCBuddyAllocator* JCBuddyAllocatorRef;
typedef const struct JCBuddyAllocator* JCBuddyAllocatorRefC;

//JCBuddyAllocatorRef JCBuddyAllocatorNew(JCULong maxChunks, JCULong chunkSize, JCULong chunkUnit);
JCBuddyAllocatorRef JCBuddyAllocatorNew(JCULong maxChunkSize, JCULong maxChunkUnit);
void JCBuddyAllocatorDelete(JCBuddyAllocatorRef allocator);
void* JCBuddyAllocatorAlloc(JCBuddyAllocatorRef allocator, JCULong capacity);
void JCBuddyAllocatorFree(JCBuddyAllocatorRef allocator, void* buf);
JCAllocatorInfo JCBuddyAllocatorGetInfo(JCBuddyAllocatorRefC allocator);

//JCAllocatorRef JCMakeBuddyAllocator(JCULong maxChunks, JCULong chunkSize, JCULong chunkUnit);
JCAllocatorRef JCMakeBuddyAllocator(JCULong maxChunkSize, JCULong maxChunkUnit);

JC_END

#endif /* JCMemoryPool_h */
