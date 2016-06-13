//
//  JWAnimationSet.h
//  June Winter_game
//
//  Created by ddeyes on 16/2/26.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>

@protocol JIAnimationSet <JIComponent>

- (void) addAnimation:(id<JIAnimation>)animation;
- (void) removeAnimation:(id<JIAnimation>)animation;
- (id<JIAnimation>) animationForId:(NSString*)animationId;
- (void) enumAnimationUsing:(void (^)(id<JIAnimation> animation, NSUInteger idx, BOOL* stop))block;

@end

@interface JWAnimationSet : JWComponent <JIAnimationSet>

@end
