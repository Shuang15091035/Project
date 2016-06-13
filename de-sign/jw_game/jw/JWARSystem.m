//
//  JWARSystem.m
//  June Winter_game
//
//  Created by GavinLo on 15/3/5.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWARSystem.h"
#import <jw/JWGameEngine.h>

@interface JWARConfig : NSObject <JIARConfig> {
    UIInterfaceOrientation mCameraOrientation;
}

@end

@implementation JWARConfig

@synthesize cameraOrientation = mCameraOrientation;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mCameraOrientation = UIInterfaceOrientationLandscapeLeft;
    }
    return self;
}

@end

@implementation JWARSystem

- (id)initWithEngine:(id<JIGameEngine>)engine {
    self = [super init];
    if (self != nil) {
        mEngine = engine;
    }
    return self;
}

@synthesize engine = mEngine;

- (id<JIARConfig>)config {
    if (mConfig == nil) {
        mConfig = [[JWARConfig alloc] init];
    }
    return mConfig;
}

- (void)initAR {
    
}

- (void)prepareAR {
    
}

- (void)startAR {
    
}

- (void)resumeAR {
    
}

- (void)pauseAR {
    
}

- (void)stopAR {
    
}

- (id<JIARImageTracker>)imageTracker {
    return mImageTracker;
}

@synthesize listener = mListener;

+ (NSString *)errorDomain {
    return @"AR System Error";
}

@end
