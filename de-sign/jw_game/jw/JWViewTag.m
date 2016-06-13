//
//  JWViewTag.m
//  June Winter_game
//
//  Created by ddeyes on 15/10/21.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWViewTag.h"

@implementation JWViewTag

- (void)onDestroy {
    if (mOnObjectDestroy != nil) {
        mOnObjectDestroy(self);
    }
    mOnObjectDestroy = nil;
    mView = nil;
    [super onDestroy];
}

@synthesize view = mView;
@synthesize viewOffset = mViewOffset;

- (void)notifyViewUpdate {
    // subclass override
}

- (JWViewTagOnChangeBlock)onChange {
    return mOnChange;
}

- (void)setOnChange:(JWViewTagOnChangeBlock)onChange {
    mOnChange = onChange;
}

- (JWViewTagOnObjectDestroyBlock)onObjectDestroy {
    return mOnObjectDestroy;
}

- (void)setOnObjectDestroy:(JWViewTagOnObjectDestroyBlock)onObjectDestroy {
    mOnObjectDestroy = onObjectDestroy;
}

- (void)setVisible:(BOOL)visible {
    [super setVisible:visible];
    if (mView != nil) {
        mView.hidden = !visible;
    }
}

- (void)onAddToHost:(id<JIGameObject>)host {
    [super onAddToHost:host];
    if (mView != nil) {
        mView.hidden = !self.isVisible;
    }
}

- (void)onRemoveFromHost:(id<JIGameObject>)host {
    [super onRemoveFromHost:host];
    if (mView != nil) {
        mView.hidden = YES;
    }
}

@end
