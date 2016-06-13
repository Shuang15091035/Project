//
//  JWTimer.m
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWTimer.h"

@implementation JWTimer
{
    NSUInteger mFrameSmoothingTime;
    
    NSMutableArray* mTimeQueue;
    NSUInteger mBaseTime;
    NSUInteger mPauseTime;
    
    id<JIEventQueue> mEventQueue;
}

+ (id)timerWith:(id<JITimeUpdatable>)updatable
{
    return [[self alloc] initWith:updatable];
}

- (id)initWith:(id<JITimeUpdatable>)updatable
{
    self = [super init];
    if(self != nil)
    {
        [self onCreate];
        mUpdatable = updatable;
    }
    return self;
}

- (void)onCreate
{
    [super onCreate];
    mCycle = 17;
    mPaused = YES;
    
    mFrameSmoothingTime = 17;
    mTimeQueue = [NSMutableArray array];
}

- (void)onDestroy
{
    mUpdatable = nil;
    [super onDestroy];
}

- (id<JITimeUpdatable>)updatable
{
    return mUpdatable;
}

- (void)setUpdatable:(id<JITimeUpdatable>)updatable
{
    mUpdatable = updatable;
}

- (float)frequency
{
    return 1.0f / ((float)mCycle / 1000.0f);
}

- (void)setFrequency:(float)frequency
{
    mCycle = (long)((1.0f / frequency) * 1000.0f);
}

- (void)start
{
    [self startDelayed:0];
}

- (void)startDelayed:(NSUInteger)delay
{
    if(!self.isPaused)
        return;
    self.paused = NO;
    
    if(delay == 0)
        [self run];
    else
        [self postDelay:delay];
}

- (void) postDelay:(long)delay
{
    [self performSelector:@selector(run) withObject:nil afterDelay:((float)delay / 1000.0f)];
}

- (void)pause
{
    self.paused = YES;
}

- (BOOL)isPaused
{
    return mPaused;
}

- (void)setPaused:(BOOL)paused
{
    mPaused = paused;
}

- (NSUInteger)totalTime
{
    return mTotalTime;
}

- (NSUInteger)elapsedTime
{
    return mElapsedTime;
}

- (void)update
{
    long now = [JWTimer currentMilliseconds] - mBaseTime;
    {
        [mTimeQueue addObject:[NSNumber numberWithLong:now]];
        
        NSInteger ts = mTimeQueue.count;
        if(ts == 1)
        {
            mElapsedTime = 0;
        }
        else
        {
            long discardThreshold = mFrameSmoothingTime;
            NSInteger it = 0;
            NSInteger end = ts - 2;
            while(it < end)
            {
                NSInteger t = [(NSNumber*)[mTimeQueue objectAtIndex:it] integerValue];
                if(now - t > discardThreshold)
                    ++it;
                else
                    break;
            }
            
            for(int i = 0; i < it; i++)
                [mTimeQueue removeObjectAtIndex:0];
            
            ts = mTimeQueue.count;
            long front = [(NSNumber*)[mTimeQueue objectAtIndex:0] longValue];
            long back = [(NSNumber*)[mTimeQueue objectAtIndex:(ts - 1)] longValue];
            mElapsedTime = (back - front) / (ts - 1);
        }
        
        mTotalTime += mElapsedTime;
    }
    
    [self onUpdateAtTotalTime:mTotalTime elapsedTime:mElapsedTime];
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime
{
    if(mUpdatable != nil)
        [mUpdatable onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
}

- (void) run
{
    if(self.isPaused)
        return;
    
    if(mPauseTime > 0)
    {
        mBaseTime += [JWTimer currentMilliseconds] - mPauseTime;
        mPauseTime = 0;
    }
    
    long timeSpent = [JWTimer currentMilliseconds];
    [self update];
    timeSpent = [JWTimer currentMilliseconds] - timeSpent;
    
    long delay = mCycle;
    if(timeSpent > mCycle)
        delay = 1;
    else
        delay = mCycle - timeSpent;
    
    [self postDelay:delay];
}

+ (NSUInteger)currentMilliseconds
{
    return [[NSProcessInfo processInfo] systemUptime] * 1000;
}

@end
