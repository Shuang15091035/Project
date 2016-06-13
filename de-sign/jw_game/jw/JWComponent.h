//
//  JWComponent.h
//  June Winter
//
//  Created by GavinLo on 14-4-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWEntity.h>
#import <jw/JWTimer.h>
#import <jw/JWGameEvents.h>

/**
 组件，是GameObject所承载的内容
 */
@protocol JIComponent <JIEntity, JITimeUpdatable>

@property (nonatomic, readonly) id<JIGameContext> context;
@property (nonatomic, readonly) id<JIGameObject> host;
@property (nonatomic, readonly) id<JITransform> transform;
@property (nonatomic, readwrite, getter = isEnabled) BOOL enabled;

@property (nonatomic, readwrite) id extra;

- (id<JIComponent>) copyInstance;

@end

@interface JWComponent : JWEntity <JIComponent> {
    id<JIGameContext> mContext;
    id<JIGameObject> mHost;
    BOOL mEnabled;
    
    id mExtra;
}

- (id) initWithContext:(id<JIGameContext>)context;
- (void) onComponentUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime;
- (void) onComponentTransformChanged:(id<JITransform>)transform;
@property (nonatomic, readonly) id<JIRenderTimer> renderTimer;
- (void) requestRender;

- (void) onAddToHost:(id<JIGameObject>)host;
- (void) onRemoveFromHost:(id<JIGameObject>)host;
- (void) notifyQueue:(id<JIRenderQueue>)queue;
- (void) onTransformChanged:(id<JITransform>)transform;

@end

/**
 * 组件组合，相当于一个组件的容器
 * TODO 重构，不使用JIUList
 */
@protocol JIComponentSet <JIComponent, JIGameEvents>

- (BOOL) addComponent:(id<JIComponent>)component;
- (BOOL) removeComponent:(id<JIComponent>)component;
- (void) removeAllComponents;
@property (nonatomic, readonly) id<JIUList> components;

@end

@interface JWComponentSet : JWComponent <JIComponentSet>

@end
