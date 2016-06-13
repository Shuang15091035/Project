//
//  JWAppState.h
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWAppPredef.h>
#import <jw/JWState.h>
#import <jw/JWAppEvents.h>

/**
 * app状态接口,除了逻辑以外还包含ui的绑定
 */
@protocol JIAppState <JIState, JIAppEvents>

/**
 * 创建ui
 * **需要子类实现
 */
- (UIView*) onCreateView:(UIView*)parent;

/**
 * 状态创建完毕调用
 */
- (void) onCreated;

@property (nonatomic, readonly) UIView* view;
@property (nonatomic, readonly) JWViewEventBinder* viewEventBinder;
@property (nonatomic, readonly) JWGestureEventBinder* gestureEventBinder;

@end

/**
 * app状态
 */
@interface JWAppState : JWState <JIAppState>

@end
