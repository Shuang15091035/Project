//
//  TutorialPlanEditChangeToEditorCamera.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TutorialPlanEditChangeToEditorCamera.h"
#import "GamePhotographer.h"
#import "MesherModel.h"

@interface TutorialPlanEditChangeToEditorCamera() {
    UIImage *btn_vr_camera_n;
    UIImageView *lo_teach_tap_static;
    UIButton *btn_bird_camera;
    UIButton *btn_editor_camera;
    UIImageView *lo_teachTap_animation;
    UIImageView *lo_cg;
}

@end

@implementation TutorialPlanEditChangeToEditorCamera

- (UIView *)onCreateView:(UIView *)parent {
    btn_vr_camera_n = [UIImage imageByResourceDrawable:@"btn_vr_camera_n"];
    lo_teach_tap_static = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap_static];
    btn_bird_camera = (UIButton*)[parent viewWithTag:R_id_btn_brid_camera];
    btn_editor_camera = (UIButton*)[parent viewWithTag:R_id_btn_editor_camera];
    [btn_editor_camera addTarget:self action:@selector(toEditorCamera) forControlEvents:UIControlEventTouchUpInside];
    lo_teachTap_animation = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap];
    lo_cg = (UIImageView*)[parent viewWithTag:R_id_lo_cg];
    
    return nil;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    [self updateUndoRedoState];
    btn_bird_camera.userInteractionEnabled = NO;
    btn_editor_camera.userInteractionEnabled = YES;
    lo_cg.alpha = 0.0f;
    [lo_teachTap_animation stopAnimating];
    lo_teach_tap_static.alpha = 0.0f;
    [lo_teach_tap_static.layer removeAllAnimations];
    lo_teachTap_animation.alpha = 1.0f;
    lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_teachTap_animation.layoutParams.marginBottom = [self uiHeightBy:136.0f];
        lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:100.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:70.0f] + btn_vr_camera_n.size.width*3.5;
    }
    [lo_teachTap_animation startAnimating];
}

- (void)onStateLeave {
    btn_editor_camera.userInteractionEnabled = NO;
    [super onStateLeave];
}

- (void)toEditorCamera {
    [lo_teachTap_animation stopAnimating];
    lo_teachTap_animation.alpha = 0.0f;
    lo_teach_tap_static.alpha = 0.0f;
    [lo_teach_tap_static.layer removeAllAnimations];
    [mModel.photographer changeToEditorCamera:1000];
    btn_editor_camera.selected = YES;
    btn_bird_camera.selected = NO;
    
    lo_cg.alpha = 1.0f;
    [UIView animateWithDuration:2.5 animations:^{
        lo_cg.alpha = 0.9f;
        [lo_cg startAnimating];
    } completion:^(BOOL finished) {
        lo_cg.alpha = 1.0f;
        [UIView animateWithDuration:1.0f animations:^{
            lo_cg.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [lo_cg stopAnimating];
            lo_teach_tap_static.alpha = 0.0f;
            [self.parentMachine changeStateTo:[States EducationShot] pushState:NO];
        }];
    }];
}

@end
