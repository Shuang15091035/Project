//
//  JWUpdateTimer.m
//  June Winter
//
//  Created by GavinLo on 15/1/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWUpdateTimer.h"

@implementation JWUpdateTimer

- (id<JIEventQueue>)eventQueue
{
    if(mEventQueue == nil)
        mEventQueue = [JWEventQueue queue];
    return mEventQueue;
}

@end
