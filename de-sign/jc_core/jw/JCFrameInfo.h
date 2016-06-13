//
//  JCFrameInfo.h
//  June Winter
//
//  Created by GavinLo on 15/3/9.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCFrameInfo__
#define __jw__JCFrameInfo__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct {
    
    float avgFPS;
    float bestFPS;
    long bestFrameTime;
    float worstFPS;
    long worstFrameTime;
    
// private
    float _lastFPS;
    long _lastTime;
    long _lastSecond;
    long _frameCount;
    
}JCFrameInfo;

JCFrameInfo JCFrameInfoMake();

JC_END

#endif /* defined(__jw__JCFrameInfo__) */
