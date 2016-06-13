//
//  JCAllocator.h
//  June Winter
//
//  Created by GavinLo on 16-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCAllocator__
#define __jw__JCAllocator__

#include <jw/JCBase.h>

JC_BEGIN

typedef enum {
    
    JCAllocatorUnknownSize = JCULongMax,
    
}JCAllocatorContants;

typedef struct {
    
    JCString(name, 32);
    JCULong actual; // 实际占用的内存大小
    JCULong available; // 可分配的内存总大小
    JCULong used; // 已分配的内存大小
    JCULong allocHits; // 分配内存时，命中分配器的次数
    JCULong totalAllocs; // 总分配调用数
    
}JCAllocatorInfo;

typedef JCAllocatorInfo* JCAllocatorInfoRef;
typedef const JCAllocatorInfo* JCAllocatorInfoRefC;

JCAllocatorInfo JCAllocatorInfoMake(JCStringRefC name);
float JCAllocatorInfoGetHitRate(JCAllocatorInfoRefC info);
JCStringRefC JCAllocatorInfoGetDescription(JCAllocatorInfoRefC info);

typedef void* (*JCAllocatorAllocFunc)(JCObjectRef object, size_t capacity);
typedef void (*JCAllocatorFreeFunc)(JCObjectRef object, void* data);
typedef void* (*JCAllocatorAddrFunc)(JCObjectRef object, void* data);
typedef JCAllocatorInfo (*JCAllocatorGetInfoFunc)(JCObjectRefC object);

typedef struct {
    
    JCObjectRef object;
    JCAllocatorAllocFunc alloc;
    JCAllocatorFreeFunc free;
    JCAllocatorAddrFunc addr;
    JCAllocatorGetInfoFunc info;
    
}JCAllocator;

typedef JCAllocator* JCAllocatorRef;
typedef const JCAllocator* JCAllocatorRefC;
JCAllocatorRef JCSystemAllocator();
JCAllocator JCAllocatorMake(JCObjectRef object, JCAllocatorAllocFunc alloc, JCAllocatorFreeFunc free, JCAllocatorAddrFunc addr, JCAllocatorGetInfoFunc info);
JCAllocatorRef JCAllocatorMakeRef(JCObjectRef object, JCAllocatorAllocFunc alloc, JCAllocatorFreeFunc free, JCAllocatorAddrFunc addr, JCAllocatorGetInfoFunc info);

JC_END

#endif /* defined(__jw__JCAllocator__) */
