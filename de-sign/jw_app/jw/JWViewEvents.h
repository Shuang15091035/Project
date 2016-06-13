//
//  JWViewEvents.h
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <UIKit/UIKit.h>

@protocol JIViewEvents <NSObject>

- (BOOL) onTouchDown:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL) onTouchMove:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL) onTouchUp:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL) onTouchCancel:(NSSet*)touches withEvent:(UIEvent*)event;

@end

typedef BOOL (^JWOnTouchEventBlock)(NSSet* touches, UIEvent* event);

@protocol JIViewEventsWithBlock <JIViewEvents>

@property (nonatomic, readwrite) JWOnTouchEventBlock onTouchDown;
@property (nonatomic, readwrite) JWOnTouchEventBlock onTouchMove;
@property (nonatomic, readwrite) JWOnTouchEventBlock onTouchUp;
@property (nonatomic, readwrite) JWOnTouchEventBlock onTouchCancel;

@end

@protocol JIViewEventsFilter <NSObject>

- (BOOL) whenEventsBindingWillHandleThisView:(UIView*)view;

@end

//@interface JWViewUtils : JWObject
//
//+ (void) bindEvents:(id<JIViewEvents>)events toView:(UIControl*)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter;
//
//@end

@interface JWViewEventBinder : JWObject

- (id) initWithEvents:(id<JIViewEvents>)events;

- (void) bindEventsToView:(UIView*)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter;
- (void) unbindEventsFromView:(UIView*)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter;

@end