//
//  JCRef.h
//  June Winter
//
//  Created by GavinLo on 15/1/15.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCRef__
#define __jw__JCRef__

#include <jw/JCBase.h>

JC_BEGIN

typedef void (*JCRefOnRelease)(void* object);

/**
 * 引用计数机制(TODO 未完善)
 */
typedef struct
{
    void* object;
    unsigned long* refCount;
    JCRefOnRelease onRelease;
    
}JCRef;

JCRef JCRefMake();

/**
 * 分配引用计数,当前refCount=1
 */
void JCRefAlloc(JCRef* ref, void* object, JCRefOnRelease onRelease);

/**
 * 释放引用技术对象,跟refCount无关
 */
void JCRefFree(JCRef* ref);

/**
 * 增加引用计数,当前refCount++
 */
void JCRefRetain(JCRef* ref);

/**
 * 减少引用计数,当前refCount--,若此时refCount==0,则调用onRelease
 */
void JCRefRelease(JCRef* ref);

JC_END

#endif /* defined(__jw__JCRef__) */
