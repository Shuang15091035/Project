//
//  JWMojingGamepad.m
//  June Winter
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMojingGamepad.h"
#import <jw/JWGameEngine.h>
#import <MojingSDK/MojingGamepad.h>

@interface JWMojingGamepad () {
    BOOL mOkIsDown;
    BOOL mBackIsDown;
}

@end

@implementation JWMojingGamepad

- (id)initWithEngine:(id<JIGameEngine>)engine {
    self = [super initWithEngine:engine];
    if (self != nil) {
        [MojingGamepad sharedGamepad].axisValueChangedHandler = ^(NSString* peripheralName, AXIS_GAMEPAD axisID, float xValue, float yValue) {
            [self reset];
            JWGamepadAxis axis = JWGamepadAxisUnknown;
            switch (axisID) {
                case AXIS_LEFT: {
                    axis = JWGamepadAxisLeft;
                    break;
                }
                case AXIS_RIGHT: {
                    axis = JWGamepadAxisRight;
                    break;
                }
                default: // TODO
                    break;
            }
            [self setEvent:JWGamepadEventAxisValueChanged byAxis:axis offset:JCVector2Make(xValue, yValue)];
            [engine onGamepad:self];
        };
        [MojingGamepad sharedGamepad].buttonValueChangedHandler = ^void(NSString* peripheralName, AXIS_GAMEPAD axisID, KEY_GAMEPAD keyID, BOOL pressed) {
            [self reset];
            switch (keyID) {
                case KEY_OK: {
                    [self setEvent:(mOkIsDown ? JWGamepadEventKeyUp : JWGamepadEventKeyDown) byKey:JWGamepadKeyOk];
                    mOkIsDown = !mOkIsDown;
                    break;
                }
                case KEY_BACK: {
                    [self setEvent:(mBackIsDown ? JWGamepadEventKeyUp : JWGamepadEventKeyDown) byKey:JWGamepadKeyBack];
                    mBackIsDown = !mBackIsDown;
                    break;
                }
                case KEY_LEFT: {
                    [self setEvent:JWGamepadEventKeyDown byKey:JWGamepadKeyLeft];
                    break;
                }
                case KEY_UP: {
                    [self setEvent:JWGamepadEventKeyDown byKey:JWGamepadKeyUp];
                    break;
                }
                default: // TODO
                    break;
            }
            [engine onGamepad:self];
        };
    }
    return self;
}

- (void)disconnect {
    [[MojingGamepad sharedGamepad] disconnect];
}

@end
