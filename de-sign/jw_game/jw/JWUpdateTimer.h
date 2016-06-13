//
//  JWUpdateTimer.h
//  June Winter
//
//  Created by GavinLo on 15/1/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWTimer.h>
#import <jw/JWEventQueue.h>

@protocol JIUpdateTimer <JITimer>

@property (nonatomic, readonly) id<JIEventQueue> eventQueue;

@end

@interface JWUpdateTimer : JWTimer <JIUpdateTimer>
{
    id<JIEventQueue> mEventQueue;
}

@end
