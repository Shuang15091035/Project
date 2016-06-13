//
//  JWAppEvents.h
//  June Winter
//
//  Created by GavinLo on 14/11/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWViewEvents.h>
#import <jw/JWGestureEvents.h>

@protocol JIAppEvents <JIViewEvents, JIGestrueEvents>

@end

@protocol JIAppEventsWithBlocks <JIViewEventsWithBlock, JIGestrueEventsWithBlocks>

@end

@interface JWAppEventBinder : JWObject

- (id) initWithEvents:(id<JIAppEvents>)events;

- (void) bindEventsToView:(UIView*)view willBindSubviews:(BOOL)bindSubviews andFilter:(id<JIViewEventsFilter>)filter;
- (void) unbindEventsFromView:(UIView*)view willUnbindSubviews:(BOOL)unbindSubviews andFilter:(id<JIViewEventsFilter>)filter;

@property (nonatomic, readonly) JWViewEventBinder* viewEventBinder;
@property (nonatomic, readonly) JWGestureEventBinder* gestureEventBinder;

@end
