//
//  JWARImageTracker.m
//  June Winter_game
//
//  Created by GavinLo on 15/3/5.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWARImageTracker.h"
#import <jw/JWList.h>

@implementation JWARImageTracker

- (id<JIUList>)targets {
    if (mTargets == nil) {
        mTargets = [JWSafeUList list];
    }
    return mTargets;
}

- (BOOL)initTracker {
    return NO;
}

- (BOOL)startTracker {
    return NO;
}

- (BOOL)stopTracker {
    return NO;
}

@synthesize enabled = mEnabled;

- (void)registerImageTarget:(id<JIARImageTarget>)target {
    id<JIUList> targets = self.targets;
    [targets addObject:target likeASet:YES];
}

- (void)unregisterImageTarget:(id<JIARImageTarget>)target {
    id<JIUList> targets = self.targets;
    [targets removeObject:target];
}

@end
