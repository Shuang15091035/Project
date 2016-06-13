//
//  JWGamepadManager.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>

typedef void (^JWGamepadManagerOnScanBlock)(id<JIGamepad> gamepad);

@protocol JIGamepadManager <JIObject>

- (BOOL) startScan:(JWGamepadManagerOnScanBlock)onScan;
- (void) stopScan;

@end

@interface JWGamepadManager : JWObject <JIGamepadManager> {
    id<JIGameEngine> mEngine;
}

- (id) initWithEngine:(id<JIGameEngine>)engine;

@end
