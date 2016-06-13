//
//  JWAppEvents.m
//  June Winter
//
//  Created by GavinLo on 14/11/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAppEvents.h"
#import "JWCoreUtils.h"

@interface JWAppEventBinder () {
    id<JIAppEvents> mEvents;
    JWViewEventBinder* mViewEventBinder;
    JWGestureEventBinder* mGestureEventBinder;
}

@end

@implementation JWAppEventBinder

- (id)initWithEvents:(id<JIAppEvents>)events
{
    self = [super init];
    if(self != nil)
    {
        mEvents = events;
    }
    return self;
}

- (void)onDestroy
{
    [JWCoreUtils destroyObject:mViewEventBinder];
    mViewEventBinder = nil;
    [JWCoreUtils destroyObject:mGestureEventBinder];
    mGestureEventBinder = nil;
    
    [super onDestroy];
}

- (JWViewEventBinder *)viewEventBinder
{
    if(mViewEventBinder == nil)
        mViewEventBinder = [[JWViewEventBinder alloc] initWithEvents:mEvents];
    return mViewEventBinder;
}

- (JWGestureEventBinder *)gestureEventBinder
{
    if(mGestureEventBinder == nil)
        mGestureEventBinder = [[JWGestureEventBinder alloc] initWithEvents:mEvents];
    return mGestureEventBinder;
}

- (void)bindEventsToView:(UIView *)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter
{
    [self.viewEventBinder bindEventsToView:view willBindSubviews:bindSubviews andFilter:filter];
    [self.gestureEventBinder bindEventsToView:view willBindSubviews:bindSubviews andFilter:filter];
}

- (void)unbindEventsFromView:(UIView *)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter
{
    [self.viewEventBinder unbindEventsFromView:view willUnbindSubviews:unbindSubviews andFilter:filter];
    [self.gestureEventBinder unbindEventsFromView:view willUnbindSubviews:unbindSubviews andFilter:filter];
}

@end
