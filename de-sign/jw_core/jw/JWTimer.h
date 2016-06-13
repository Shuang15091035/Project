//
//  JWTimer.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

@protocol JITimeUpdatable <NSObject>

- (void) onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime;

@end

@protocol JITimer <JIObject, JITimeUpdatable>

@property (nonatomic, readwrite) id<JITimeUpdatable> updatable;
@property (nonatomic, readwrite) float frequency;

- (void) start;
- (void) startDelayed:(NSUInteger)delay;
- (void) pause;
@property (nonatomic, readwrite, getter = isPaused) BOOL paused;

@property (nonatomic, readonly) NSUInteger totalTime;
@property (nonatomic, readonly) NSUInteger elapsedTime;

- (void) update;

@end

@interface JWTimer : JWObject <JITimer>
{
    NSUInteger mCycle;
    BOOL mPaused;
    
    NSUInteger mTotalTime;
    NSUInteger mElapsedTime;
    
    id<JITimeUpdatable> mUpdatable;
}

+ timerWith:(id<JITimeUpdatable>)updatable;
- initWith:(id<JITimeUpdatable>)updatable;

+ (NSUInteger) currentMilliseconds;

@end
