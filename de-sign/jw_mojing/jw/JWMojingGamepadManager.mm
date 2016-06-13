//
//  JWMojingGamepadManager.m
//  June Winter
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMojingGamepadManager.h"
#import "JWMojingGamepad.h"
#import <MojingSDK/MojingGamepad.h>

@interface JWMojingGamepadManager () {
    JWMojingGamepad* mSharedGamepad;
}

@end

@implementation JWMojingGamepadManager

- (BOOL)startScan:(JWGamepadManagerOnScanBlock)onScan {
    [[MojingGamepad sharedGamepad] scan];
    if (mSharedGamepad == nil) {
        mSharedGamepad = [[JWMojingGamepad alloc] initWithEngine:mEngine];
        [mSharedGamepad setId:0];
    }
    if (onScan != nil) {
        onScan(mSharedGamepad);
    }
    return YES;
}

- (void)stopScan {
    [[MojingGamepad sharedGamepad] stopScan];
}

@end
