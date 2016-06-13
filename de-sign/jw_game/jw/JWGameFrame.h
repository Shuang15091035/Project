//
//  JWGameFrame.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWObject.h>
#import <jw/JWGame.h>

#define JWGameFrameTag 0xeffe

typedef NS_ENUM(NSInteger, JWGameFrameRenderMode)
{
    JWGameFrameRenderModeWhenDirty,
    JWGameFrameRenderModeContinuously,
};

@protocol JIGameFrame <JIObject>

@property (nonatomic, readwrite) JWGameFrameRenderMode renderMode;
- (void) requestRender;

@property (nonatomic, readonly) id<JIGameEngine> engine;
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) float height;
@property (nonatomic, readonly) UIView* view;

@end

@interface JWGameFrame : JWObject <JIGameFrame>
{
    id<JIGameEngine> mEngine;
    JWGameFrameRenderMode mRenderMode;
    UIView* mView;
}

- (id) initWithEngine:(id<JIGameEngine>) engine;
- (UIView*) onCreateView;

@end
