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

@end
