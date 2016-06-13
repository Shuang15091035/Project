//
//  JWGestureEvents.m
//  June Winter
//
//  Created by GavinLo on 14/11/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGestureEvents.h"
#import "JCFlags.h"
#import <jw/UIView+JWUiCategory.h>

//@interface JWGestureEventEntry : NSObject
//
//@property (nonatomic, readwrite) UIView* view;
//@property (nonatomic, readwrite) UIPinchGestureRecognizer* pinchGestureRecognizer;
//@property (nonatomic, readwrite) UITapGestureRecognizer* singleTapGestureRecognizer;
//@property (nonatomic, readwrite) UITapGestureRecognizer* doubleTapGestureRecognizer;
//
//@end
//
//@implementation JWGestureEventEntry
//
//@synthesize view;
//@synthesize pinchGestureRecognizer;
//@synthesize singleTapGestureRecognizer;
//@synthesize doubleTapGestureRecognizer;
//
//@end

@interface JWGestureEventBinder () {
    id<JIGestrueEvents> mEvents;
    // NOTE 不使用以下变量记录GestureRecognizer是为了能同时支持多个控件都有手势操作，以下变量只记录最近一次绑定的手势
    UIPinchGestureRecognizer* mPinchGestureRecognizer;
    UITapGestureRecognizer* mSingleTapGestureRecognizer;
//    UITapGestureRecognizer* mDoubleTapGestureRecognizer;
    UILongPressGestureRecognizer* mLongPressGestureRecognizer;
}

@end

@implementation JWGestureEventBinder

- (id)initWithEvents:(id<JIGestrueEvents>)events {
    self = [super init];
    if (self != nil) {
        mEvents = events;
    }
    return self;
}

- (void)onDestroy {
    mEvents = nil;
//    mPinchGestureRecognizer = nil;
//    mSingleTapGestureRecognizer = nil;
//    mDoubleTapGestureRecognizer = nil;
    [super onDestroy];
}

- (void)bindEventsWithType:(JWGestureType)type toView:(UIView *)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter {
    if (view == nil) {
        return;
    }
    if (filter != nil) {
        if (![filter whenEventsBindingWillHandleThisView:view]) {
            return;
        }
    }
    
    [self bindTarget:self withType:type toView:view];
    
    if (bindSubviews) {
        NSArray* subviews = view.subviews;
        if (subviews != nil) {
            for(UIView* subview in subviews)
                [self bindEventsWithType:type toView:subview willBindSubviews:bindSubviews andFilter:filter];
        }
    }
}

- (void)bindEventsToView:(UIView *)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter {
    [self bindEventsWithType:JWGestureTypeAll toView:view willBindSubviews:bindSubviews andFilter:filter];
}

- (void)unbindEventsWithType:(JWGestureType)type fromView:(UIView *)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter {
    if (view == nil) {
        return;
    }
    if (filter != nil) {
        if (![filter whenEventsBindingWillHandleThisView:view]) {
            return;
        }
    }
    
    [self unbindTarget:self withType:type fromView:view];
    
    if(unbindSubviews)
    {
        NSArray* subviews = view.subviews;
        if(subviews != nil)
        {
            for(UIView* subview in subviews)
                [self unbindEventsWithType:type fromView:subview willUnbindSubviews:unbindSubviews andFilter:filter];
        }
    }
}

- (void)unbindEventsFromView:(UIView *)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter {
    [self unbindEventsWithType:JWGestureTypeAll fromView:view willUnbindSubviews:unbindSubviews andFilter:filter];
}

- (void) bindTarget:(id)target withType:(JWGestureType)type toView:(UIView*)view {
    if (JCFlagsTest(type, JWGestureTypePinch)) {
//        if(mPinchGestureRecognizer == nil)
//            mPinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];
        UIPinchGestureRecognizer* pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];
        [view addGestureRecognizer:pinchGestureRecognizer];
        mPinchGestureRecognizer = pinchGestureRecognizer;
    }
    if (JCFlagsTest(type, JWGestureTypeSingleTap)) {
//        if(mSingleTapGestureRecognizer == nil) {
//            mSingleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
//            mSingleTapGestureRecognizer.numberOfTapsRequired = 1;
//        }
        UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:singleTapGestureRecognizer];
        mSingleTapGestureRecognizer = singleTapGestureRecognizer;
    }
    if (JCFlagsTest(type, JWGestureTypeDoubleTap)) {
//        if(mDoubleTapGestureRecognizer == nil)
//        {
//            mDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
//            mDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
//        }
        UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        [view addGestureRecognizer:doubleTapGestureRecognizer];
    }
    if (JCFlagsTest(type, JWGestureTypeDoubleDrag)) {
        UIPanGestureRecognizer* doubleDragGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleDrag:)];
        doubleDragGestureRecognizer.minimumNumberOfTouches = 2;
        doubleDragGestureRecognizer.maximumNumberOfTouches = 2;
        [view addGestureRecognizer:doubleDragGestureRecognizer];
    }
    if (JCFlagsTest(type, JWGestureTypeLongPress)) {
        UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [view addGestureRecognizer:longPressGestureRecognizer];
        mLongPressGestureRecognizer = longPressGestureRecognizer;
    }
}

- (void) unbindTarget:(id)target withType:(JWGestureType)type fromView:(UIView*)view
{
//    if(JCFlagsTest(type, JWGestureTypePinch)) {
//        [view removeGestureRecognizer:mPinchGestureRecognizer];
//    }
//    if(JCFlagsTest(type, JWGestureTypeSingleTap)) {
//        [view removeGestureRecognizer:mSingleTapGestureRecognizer];
//    }
//    if(JCFlagsTest(type, JWGestureTypeSingleTap)) {
//        [view removeGestureRecognizer:mDoubleTapGestureRecognizer];
//    }
    [view removeAllGestureRecognizers];
}

- (void) onPinch:(UIPinchGestureRecognizer*)pinch {
    [mEvents onPinch:pinch];
}

- (void) onSingleTap:(UITapGestureRecognizer*)singleTap {
    [mEvents onSingleTap:singleTap];
}

- (void) onDoubleTap:(UITapGestureRecognizer*)doubleTap {
    [mEvents onDoubleTap:doubleTap];
}

- (void) onDoubleDrag:(UIPanGestureRecognizer*)doubleDrag {
    [mEvents onDoubleDrag:doubleDrag];
}

- (void) onLongPress:(UILongPressGestureRecognizer*)longPress {
    [mEvents onLongPress:longPress];
}

- (UIPinchGestureRecognizer *)lastPinchGestureRecognizer {
    return mPinchGestureRecognizer;
}

- (UITapGestureRecognizer *)lastSingleTapGestureRecognizer {
    return mSingleTapGestureRecognizer;
}

//- (UITapGestureRecognizer *)doubleTapGestureRecognizer
//{
//    return mDoubleTapGestureRecognizer;
//}

- (UILongPressGestureRecognizer *)lastLongPressGestureRecognizer {
    return mLongPressGestureRecognizer;
}

@end
