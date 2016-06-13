//
//  JWParticle.m
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWParticle.h"

@interface JWParticle () {
    NSUInteger mDeathTime;
    BOOL mDead;
    
    NSUInteger mLifeTime;
}

@end

@implementation JWParticle

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        mDeathTime = -1;
        mDead = NO;
        mLifeTime = 0;
    }
    return self;
}

@synthesize deathTime = mDeathTime;
@synthesize dead = mDead;

- (void)kill {
    mDead = YES;
}

- (void)reset {
    mDeathTime = -1;
    mDead = NO;
    mLifeTime = 0;
}

- (void)onComponentUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    [super onComponentUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    if (mDead) {
        return;
    }
    mLifeTime += elapsedTime;
    if (mDeathTime > 0 && mLifeTime > mDeathTime) {
        mDead = YES;
    }
}

@end
