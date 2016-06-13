//
//  JWControllerState.h
//  June Winter
//
//  Created by GavinLo on 14-2-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWAppState.h>

/**
 * 把JWStateController转换成一个真正的状态
 */
@interface JWControllerState : JWAppState

- (id) initWithClass:(Class)controllerClass parent:(UIViewController*)parent containerId:(NSInteger)containerId;
- (id) initWithController:(JWStateController*)controller parent:(UIViewController*)parent containerId:(NSInteger)containerId;
+ (id) stateWithClass:(Class)controllerClass parent:(UIViewController*)parent containerId:(NSInteger)containerId;
+ (id) stateWithController:(JWStateController*)controller parent:(UIViewController*)parent containerId:(NSInteger)containerId;

@property (nonatomic, readonly) Class controllerClass;

@end

@interface UIViewController (JWAppCategory)

- (void) showContentController:(UIViewController*)content containerId:(NSInteger)containerId;
- (void) hideContentController:(UIViewController*)content;

@end
