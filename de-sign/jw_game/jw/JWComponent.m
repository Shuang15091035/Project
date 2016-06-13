//
//  JWComponent.m
//  June Winter
//
//  Created by GavinLo on 14-4-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWComponent.h"
#import "JWGameObject.h"
#import "JWGameEngine.h"
#import "JWRenderTimer.h"

#import <jw/JWCoreUtils.h>
#import <jw/JWList.h>
#import <jw/JWCamera.h>
#import <jw/JWLight.h>
#import <jw/JWBehaviour.h>

@implementation JWComponent

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super init];
    if (self != nil) {
        mContext = context;
        [self onCreate];
    }
    return self;
}

- (void)onCreate {
    [super onCreate];
    mEnabled = YES;
}

- (id<JIGameContext>)context {
    return mContext;
}

- (id<JIGameObject>)host {
    return mHost;
}

- (id<JITransform>)transform {
    if (mHost == nil) {
        return nil;
    }
    return mHost.transform;
}

- (BOOL)isEnabled {
    return mEnabled;
}

- (void)setEnabled:(BOOL)enabled {
    mEnabled = enabled;
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    if (!mEnabled) {
        return;
    }
    [self onComponentUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
}

- (void)onComponentUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    
}

- (id<JIRenderTimer>)renderTimer {
    if (mContext == nil || mContext.engine == nil) {
        return nil;
    }
    return mContext.engine.renderTimer;
}

- (void)requestRender {
    id<JIRenderTimer> renderTimer = self.renderTimer;
    [renderTimer requestRender];
}

- (id)extra {
    return mExtra;
}

- (void)setExtra:(id)extra {
    mExtra = extra;
}

- (id<JIComponent>)copyInstance {
    // subclass override
    return nil;
}

- (void)onAddToHost:(id<JIGameObject>)host {
    if (mHost != nil) {
        [mHost removeComponent:self];
    }
    mHost = host;
}

- (void)onRemoveFromHost:(id<JIGameObject>)host {
    mHost = nil;
}

- (void)notifyQueue:(id<JIRenderQueue>)queue {
    // 子类实现
}

- (void)onTransformChanged:(id<JITransform>)transform {
    if (!mEnabled) {
        return;
    }
    [self onComponentTransformChanged:transform];
}

- (void)onComponentTransformChanged:(id<JITransform>)transform {
    // subclass override
}

@end

@interface JWComponentSet () {
    id<JIUList> mComponents;
}

@property (nonatomic, readonly) id<JIUList> componentList;
@end

@implementation JWComponentSet

- (void)onDestroy {
    [JWCoreUtils destroyList:mComponents];
    mComponents = nil;
    [super onDestroy];
}

- (BOOL)addComponent:(id<JIComponent>)component {
    if (component == nil) {
        return NO;
    }
    if ([component conformsToProtocol:@protocol(JICamera)]) {
        // 不能添加Camera
        return NO;
    } else if ([component conformsToProtocol:@protocol(JILight)]) {
        // 不能添加Light
        return NO;
    }
    if ([self.componentList addObject:component likeASet:YES]) {
        JWComponent* comp = component;
        [comp onAddToHost:mHost];
    }
    return YES;
}

- (BOOL)removeComponent:(id<JIComponent>)component {
    if (component == nil) {
        return NO;
    }
    if ([self.componentList removeObject:component]) {
        JWComponent* comp = component;
        [comp onRemoveFromHost:mHost];
    }
    return YES;
}

- (void)removeAllComponents {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWComponent* comp = obj;
        [comp onRemoveFromHost:mHost];
    }];
    [self.componentList clear];
}

- (id<JIUList>)components {
    return self.componentList;
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        [component onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    }];
}

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    __block BOOL b = NO;
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            if ([behaviour onScreenTouchDown:touches withEvent:event])
            {
                b = YES;
                *stop = YES;
            }
        }
    }];
    return b;
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    __block BOOL b = NO;
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            if ([behaviour onScreenTouchMove:touches withEvent:event])
            {
                b = YES;
                *stop = YES;
            }
        }
    }];
    return b;
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    __block BOOL b = NO;
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            if ([behaviour onScreenTouchUp:touches withEvent:event])
            {
                b = YES;
                *stop = YES;
            }
        }
    }];
    return b;
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    __block BOOL b = NO;
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            if ([behaviour onScreenTouchCancel:touches withEvent:event])
            {
                b = YES;
                *stop = YES;
            }
        }
    }];
    return b;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            [behaviour onPinch:pinch];
        }
    }];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            [behaviour onSingleTap:singleTap];
        }
    }];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            [behaviour onDoubleTap:doubleTap];
        }
    }];
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            [behaviour onDoubleDrag:doubleDrag];
        }
    }];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            [behaviour onLongPress:longPress];
        }
    }];
}

- (void)onGamepad:(id<JIGamepad>)gamepad {
    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if (!component.isEnabled) {
            return;
        }
        if ([component isKindOfClass:[JWBehaviour class]])
        {
            JWBehaviour* behaviour = (JWBehaviour*)component;
            [behaviour onGamepad:gamepad];
        }
    }];
}

- (void)onAddToHost:(id<JIGameObject>)host {
    [super onAddToHost:host];
    if (host != nil) {
        [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWComponent* comp = obj;
            [comp onAddToHost:host];
        }];
    }
}

- (void)onRemoveFromHost:(id<JIGameObject>)host {
    [super onRemoveFromHost:host];
    if (host != nil) {
        [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWComponent* comp = obj;
            [comp onRemoveFromHost:host];
        }];
    }
}

- (id<JIUList>)componentList {
    if(mComponents == nil)
        mComponents = [JWSafeUList list];
    return mComponents;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(id=%@,name=%@,host=%@)", NSStringFromClass([self class]), self.Id, self.name, mHost.Id];
}

@end
