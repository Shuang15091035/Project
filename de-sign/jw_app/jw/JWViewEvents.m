//
//  JWViewEvents.m
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWViewEvents.h"

//@implementation JWViewUtils
//
//+ (void)bindEvents:(id<JIViewEvents>)events toView:(UIControl *)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter
//{
//    if(view == nil)
//        return;
//    
//    if(filter != nil)
//    {
//        if(![filter whenEventsBindingWillBindThisView:view])
//            return;
//    }
//    
//    [view addTarget:events action:@selector(onTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
//    [view addTarget:events action:@selector(onTouchMove:withEvent:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
//    [view addTarget:events action:@selector(onTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//    [view addTarget:events action:@selector(onTouchCancel:withEvent:) forControlEvents:UIControlEventTouchCancel];
//    
//    if(bindSubviews)
//    {
//        NSArray* subviews = view.subviews;
//        if(subviews != nil)
//        {
//            for(UIView* subview in subviews)
//            {
//                if([subview isKindOfClass:[UIControl class]])
//                    [self bindEvents:events toView:(UIControl*)subview willBindSubviews:bindSubviews andFilter:filter];
//            }
//        }
//    }
//}
//
//@end

@interface JWViewEventBinder ()
{
    id<JIViewEvents> mEvents;
}

@end

@implementation JWViewEventBinder

- (id)initWithEvents:(id<JIViewEvents>)events
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
    mEvents = nil;
    [super onDestroy];
}

- (void)bindEventsToView:(UIView *)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter
{
    if(view == nil)
        return;
    if(filter != nil)
    {
        if(![filter whenEventsBindingWillHandleThisView:view])
            return;
    }
    
    [self bindTarget:self toView:view];
    
    if(bindSubviews)
    {
        NSArray* subviews = view.subviews;
        if(subviews != nil)
        {
            for(UIView* subview in subviews)
                [self bindEventsToView:subview willBindSubviews:bindSubviews andFilter:filter];
        }
    }
}

- (void)unbindEventsFromView:(UIView *)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter
{
    if(view == nil)
        return;
    if(filter != nil)
    {
        if(![filter whenEventsBindingWillHandleThisView:view])
            return;
    }
    
    [self unbindTarget:self fromView:view];
    
    if(unbindSubviews)
    {
        NSArray* subviews = view.subviews;
        if(subviews != nil)
        {
            for(UIView* subview in subviews)
                [self unbindEventsFromView:subview willUnbindSubviews:unbindSubviews andFilter:filter];
        }
    }
}

- (void) bindTarget:(id)target toView:(UIView *)view
{
    if(![view isKindOfClass:[UIControl class]])
        return;
    UIControl* control = (UIControl*)view;
    //view.userInteractionEnabled = YES;
    [control addTarget:target action:@selector(onTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [control addTarget:target action:@selector(onTouchMove:withEvent:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
    [control addTarget:target action:@selector(onTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [control addTarget:target action:@selector(onTouchCancel:withEvent:) forControlEvents:UIControlEventTouchCancel];
}

- (void) unbindTarget:(id)target fromView:(UIView*)view
{
    if(![view isKindOfClass:[UIControl class]])
        return;
    UIControl* control = (UIControl*)view;
    [control removeTarget:target action:@selector(onTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [control removeTarget:target action:@selector(onTouchMove:withEvent:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
    [control removeTarget:target action:@selector(onTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [control removeTarget:target action:@selector(onTouchCancel:withEvent:) forControlEvents:UIControlEventTouchCancel];
}

- (void) onTouchDown:(UIView*)view withEvent:(UIEvent*)event
{
    NSSet* touches = [event touchesForView:view];
    BOOL b = [mEvents onTouchDown:touches withEvent:event];
    if(!b)
        [view.nextResponder touchesBegan:touches withEvent:event];
}

- (void) onTouchMove:(UIView*)view withEvent:(UIEvent*)event
{
    NSSet* touches = [event touchesForView:view];
    BOOL b = [mEvents onTouchMove:touches withEvent:event];
    if(!b)
        [view.nextResponder touchesMoved:touches withEvent:event];
}

- (void) onTouchUp:(UIView*)view withEvent:(UIEvent*)event
{
    NSSet* touches = [event touchesForView:view];
    BOOL b = [mEvents onTouchUp:touches withEvent:event];
    if(!b)
        [view.nextResponder touchesEnded:touches withEvent:event];
}

- (void) onTouchCancel:(UIView*)view withEvent:(UIEvent*)event
{
    NSSet* touches = [event touchesForView:view];
    BOOL b = [mEvents onTouchCancel:touches withEvent:event];
    if(!b)
        [view.nextResponder touchesCancelled:touches withEvent:event];
}

@end