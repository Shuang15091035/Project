//
//  JWGamepad.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JCVector2.h>

typedef NS_ENUM(NSInteger, JWGamepadAxis) {
    JWGamepadAxisUnknown,
    JWGamepadAxisLeft, // 左摇杆
    JWGamepadAxisRight, // 右摇杆
    JWGamepadAxisCustom,
};

typedef NS_ENUM(NSInteger, JWGamepadKey) {
    JWGamepadKeyUnknown,
    JWGamepadKeyLeft,
    JWGamepadKeyRight,
    JWGamepadKeyUp,
    JWGamepadKeyDown,
    JWGamepadKeyOk,
    JWGamepadKeyBack,
    JWGamepadKeyCustom,
};

typedef NS_ENUM(NSInteger, JWGamepadEvent) {
    JWGamepadEventUnknown,
    JWGamepadEventAxisValueChanged,
    JWGamepadEventKeyDown,
    JWGamepadEventKeyUp,
};

@protocol JIGamepad <JIObject>

@property (nonatomic, readonly) NSUInteger Id;
@property (nonatomic, readonly) JWGamepadEvent event;
@property (nonatomic, readonly) JWGamepadAxis axis;
@property (nonatomic, readonly) JCVector2 axisOffset;
@property (nonatomic, readonly) JWGamepadKey key;

- (void) disconnect;

@end

@interface JWGamepad : JWObject <JIGamepad> {
    id<JIGameEngine> mEngine;
    NSUInteger mId;
    JWGamepadEvent mEvent;
    JWGamepadAxis mAxis;
    JCVector2 mAxisOffset;
    JWGamepadKey mKey;
}

- (id) initWithEngine:(id<JIGameEngine>)engine;

- (void) setId:(NSUInteger)Id;
- (void) setEvent:(JWGamepadEvent)event byAxis:(JWGamepadAxis)axis offset:(JCVector2)axisOffset;
- (void) setEvent:(JWGamepadEvent)event byKey:(JWGamepadKey)key;
- (void) reset;

@end
