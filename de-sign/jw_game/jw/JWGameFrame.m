//
//  JWGameFrame.m
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGameFrame.h"

#import <jw/UIView+JWUiCategory.h>

@implementation JWGameFrame

- (id)initWithEngine:(id<JIGameEngine>)engine
{
    self = [self init];
    if(self != nil)
    {
        mEngine = engine;
        mRenderMode = JWGameFrameRenderModeWhenDirty;
    }
    return self;
}

- (UIView *)onCreateView
{
    // subclass override
    return nil;
}

- (JWGameFrameRenderMode)renderMode
{
    return mRenderMode;
}

- (void)setRenderMode:(JWGameFrameRenderMode)renderMode
{
    mRenderMode = renderMode;
}

- (void)requestRender
{
    // override this
}

- (id<JIGameEngine>)engine
{
    return mEngine;
}

- (float)width
{
    if(self.view == nil)
        return 0.0f;
    return self.view.frameInPixels.size.width;
}

- (float)height
{
    if(self.view == nil)
        return 0.0f;
    return self.view.frameInPixels.size.height;
}

- (UIView *)view
{
    if(mView == nil)
    {
        mView = [self onCreateView];
        mView.tag = JWGameFrameTag;
    }
    return mView;
}

@end
