//
//  JWGamepadManager.m
//  June Winter_game
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGamepadManager.h"

@implementation JWGamepadManager

- (id)initWithEngine:(id<JIGameEngine>)engine {
    self = [super init];
    if (self != nil) {
        mEngine = engine;
    }
    return self;
}

- (void)onDestroy {
    mEngine = nil;
    [super onDestroy];
}

- (BOOL)startScan:(JWGamepadManagerOnScanBlock)onScan {
    // subclass override
    return NO;
}

- (void)stopScan {
    // subclass override
}

@end
