//
//  BaseState.m
//  project_mesher
//
//  Created by ddeyes on 15/11/30.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "BaseState.h"
#import "MesherModel.h"
#import <Foundation/Foundation.h>

@interface BaseState() {
    UIImageView *lo_animation_imageView;
    NSMutableArray *mAnimationImages;
}

@end

@implementation BaseState

- (void)updateUndoRedoState {
    btn_redo.userInteractionEnabled = YES;
    btn_undo.userInteractionEnabled = YES;
    if (mModel.commandMachine.canUndo) {
        btn_undo.image = [UIImage imageByResourceDrawable:@"btn_undo_n.png"];
    }else {
        btn_undo.image = [UIImage imageByResourceDrawable:@"btn_undo_d.png"];
    }
    if (mModel.commandMachine.canRedo){
        btn_redo.image = [UIImage imageByResourceDrawable:@"btn_redo_n"];
    }else {
        btn_redo.image = [UIImage imageByResourceDrawable:@"btn_redo_d"];
    }
}

- (void)createLoadingAnimationView:(UIView*)parent {
    if (mAnimationImages == nil) {
        mAnimationImages = [NSMutableArray array];
    }
    if (lo_animation_imageView == nil) {
        lo_animation_imageView = [UIImageView new];
    }
    for (int i = 1; i <= 18; i++) {
        NSString *imageName = [NSString stringWithFormat:@"animation%d",i];
        UIImage *image = [UIImage imageByResourceDrawable:imageName];
        [mAnimationImages add:image];
    }
    lo_animation_imageView.image = mAnimationImages[0];
    lo_animation_imageView.layoutParams.width = CCVLayoutWrapContent;
    lo_animation_imageView.layoutParams.height = CCVLayoutWrapContent;
    lo_animation_imageView.layoutParams.alignment = CCVLayoutAlignCenterInParent;
    lo_animation_imageView.animationImages = mAnimationImages;
    lo_animation_imageView.animationDuration = 1.4;
    
    [parent addSubview:lo_animation_imageView];
}

- (void)startLoadingAnimation {
    [lo_animation_imageView startAnimating];
}

- (void)stopLoadingAnimation {
    [lo_animation_imageView stopAnimating];
}

@end
