//
//  JWGamepad.m
//  June Winter_game
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGamepad.h"

@implementation JWGamepad

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

- (NSUInteger)Id {
    return mId;
}

- (JWGamepadEvent)event {
    return mEvent;
}

- (JWGamepadAxis)axis {
    return mAxis;
}

- (JCVector2)axisOffset {
    return mAxisOffset;
}

- (JWGamepadKey)key {
    return mKey;
}

- (void)disconnect {
    
}

- (void)setId:(NSUInteger)Id {
    mId = Id;
}

- (void)setEvent:(JWGamepadEvent)event byAxis:(JWGamepadAxis)axis offset:(JCVector2)axisOffset {
    mEvent = event;
    mAxis = axis;
    mAxisOffset = axisOffset;
}

- (void)setEvent:(JWGamepadEvent)event byKey:(JWGamepadKey)key {
    mEvent = event;
    mKey = key;
}

- (void)reset {
    mEvent = JWGamepadEventUnknown;
    mAxis = JWGamepadAxisUnknown;
    mAxisOffset = JCVector2Zero();
    mKey = JWGamepadKeyUnknown;
}

@end
