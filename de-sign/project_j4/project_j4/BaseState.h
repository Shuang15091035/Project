//
//  BaseState.h
//  project_mesher
//
//  Created by ddeyes on 15/11/30.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "BaseAppState.h"

@interface BaseState : BaseAppState {
    UIImageView *btn_undo;
    UIImageView *btn_redo;
}

- (void) updateUndoRedoState;

- (void)createLoadingAnimationView:(UIView*)parent;
- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
@end
