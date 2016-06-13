//
//  JWRenderQueue.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>

@protocol JIRenderQueue <JIObject>

- (void) add:(id<JIRenderable>)renderable;
- (void) remove:(id<JIRenderable>)renderable;
@property (nonatomic, readonly) NSUInteger numRenderables;
- (void) clear;
- (void) renderBackgrounds;
- (void) renderObjects:(id<JICamera>)camera;

/**
 * 当renderable的属性产生变化时（比如说是渲染顺序（RenderOrder）或材质的透明属性（transparent））需要手动调用此方法让渲染队列重新排序，以确保渲染效果的正确性。
 * TODO 当属性改变时自动调用此方法
 */
- (void) notifyChangedByRenderable:(id<JIRenderable>)renderable;

- (void) dumpTree;

@end

@interface JWRenderQueue : JWObject <JIRenderQueue>

@end
