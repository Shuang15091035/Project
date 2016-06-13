//
//  JWGestureEvents.h
//  June Winter
//
//  Created by GavinLo on 14/11/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWViewEvents.h>

typedef NS_OPTIONS(NSUInteger, JWGestureType)
{
    JWGestureTypePinch             = 0x1 << 1,
    JWGestureTypeSingleTap     = 0x1 << 2,
    JWGestureTypeDoubleTap     = 0x1 << 3,
    JWGestureTypeDoubleDrag    = 0x1 << 4,
    JWGestureTypeLongPress     = 0x1 << 5,
    JWGestureTypeAll                   = 0xffffffff,
};

@protocol JIGestrueEvents <NSObject>

- (void) onPinch:(UIPinchGestureRecognizer*)pinch;
- (void) onSingleTap:(UITapGestureRecognizer*)singleTap;
- (void) onDoubleTap:(UITapGestureRecognizer*)doubleTap;
- (void) onDoubleDrag:(UIPanGestureRecognizer*)doubleDrag;
- (void) onLongPress:(UILongPressGestureRecognizer*)longPress;

@end

typedef void (^JWOnPinchBlock)(UIPinchGestureRecognizer* pinch);
typedef void (^JWOnSingleTapBlock)(UITapGestureRecognizer* singleTap);
typedef void (^JWOnDoubleTapBlock)(UITapGestureRecognizer* doubleTap);
typedef void (^JWOnDoubleDragBlock)(UIPanGestureRecognizer* doubleDrag);
typedef void (^JWOnLongPressBlock)(UILongPressGestureRecognizer* longPress);

@protocol JIGestrueEventsWithBlocks <JIGestrueEvents>

@property (nonatomic, readwrite) JWOnPinchBlock onPinch;
@property (nonatomic, readwrite) JWOnSingleTapBlock onSingleTap;
@property (nonatomic, readwrite) JWOnDoubleTapBlock onDoubleTap;
@property (nonatomic, readwrite) JWOnDoubleDragBlock onDoubleDrag;
@property (nonatomic, readwrite) JWOnLongPressBlock onLongPress;

@end

@interface JWGestureEventBinder : JWObject

- (id) initWithEvents:(id<JIGestrueEvents>)events;

- (void) bindEventsWithType:(JWGestureType)type toView:(UIView*)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter;
- (void) bindEventsToView:(UIView*)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter;
- (void) unbindEventsWithType:(JWGestureType)type fromView:(UIView*)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter;
- (void) unbindEventsFromView:(UIView*)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter;

@property (nonatomic, readonly) UIPinchGestureRecognizer* lastPinchGestureRecognizer;
@property (nonatomic, readonly) UITapGestureRecognizer* lastSingleTapGestureRecognizer;
//@property (nonatomic, readonly) UITapGestureRecognizer* doubleTapGestureRecognizer;
@property (nonatomic, readonly) UILongPressGestureRecognizer* lastLongPressGestureRecognizer;

@end
