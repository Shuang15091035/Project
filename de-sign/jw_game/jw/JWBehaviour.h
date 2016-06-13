//
//  JWBehaviour.h
//  June Winter
//
//  Created by GavinLo on 14/10/29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>
#import <jw/JWGameEvents.h>

typedef void (^JWOnUpdateBlock)(NSUInteger totalTime, NSUInteger elapsedTime);

@protocol JIScreenEvents <NSObject>

- (BOOL) onScreenTouchDown:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL) onScreenTouchMove:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL) onScreenTouchUp:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL) onScreenTouchCancel:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL) onScreenClick:(NSSet*)touches withEvent:(UIEvent*)event;

@end

@protocol JIScreenEventsWithBlock <JIScreenEvents>

@property (nonatomic, readwrite) JWOnTouchEventBlock onScreenTouchDown;
@property (nonatomic, readwrite) JWOnTouchEventBlock onScreenTouchMove;
@property (nonatomic, readwrite) JWOnTouchEventBlock onScreenTouchUp;
@property (nonatomic, readwrite) JWOnTouchEventBlock onScreenTouchCancel;
@property (nonatomic, readwrite) JWOnTouchEventBlock onScreenClick;

@end

@protocol JIBehaviour <JIComponent, JIGameEventsWithBlock, JIScreenEventsWithBlock>

@property (nonatomic, readwrite) JWOnUpdateBlock onUpdate;

@end

@interface JWBehaviour : JWComponent <JIBehaviour>

+ (id) behaviourWithContext:(id<JIGameContext>)context;

- (void) onBehaviourUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime;

@end
