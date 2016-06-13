//
//  JWGame.h
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWObject.h>
#import <jw/JWGameEngine.h>
#import <jw/JWGameWorld.h>

@protocol JIGame <JIObject>

- (void) onContentCreate;
- (UIView*) onUiCreate:(UIView*)parent;
- (void) onContentDestroy;

@property (nonatomic, readonly) id<JIGameEngine> engine;
@property (nonatomic, readonly) id<JIGameWorld> world;

@end

@interface JWGame : JWObject <JIGame>

- (void) setEngine:(id<JIGameEngine>)engine;

@end
