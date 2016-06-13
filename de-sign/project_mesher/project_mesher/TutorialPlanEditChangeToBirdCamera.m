//
//  TutorialPlanEditChangeToBirdCamera.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TutorialPlanEditChangeToBirdCamera.h"
#import "GamePhotographer.h"
#import "MesherModel.h"

@interface TutorialPlanEditChangeToBirdCamera() {
    UIImage *btn_vr_camera_n;
    UIImageView *lo_teach_tap_static;
    UIButton *btn_bird_camera;
    UIButton *btn_editor_camera;
    UIImageView *lo_teachTap_animation;
}

@end

@implementation TutorialPlanEditChangeToBirdCamera

- (UIView *)onCreateView:(UIView *)parent {
    btn_vr_camera_n = [UIImage imageByResourceDrawable:@"btn_vr_camera_n"];
    lo_teach_tap_static = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap_static];
    btn_bird_camera = (UIButton*)[parent viewWithTag:R_id_btn_brid_camera];
    [btn_bird_camera addTarget:self action:@selector(toBirdCamera) forControlEvents:UIControlEventTouchUpInside];
    btn_editor_camera = (UIButton*)[parent viewWithTag:R_id_btn_editor_camera];
    lo_teachTap_animation = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap];
    
    return nil;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    [self updateUndoRedoState];
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.photographer.cameraEnabled = YES;
    btn_bird_camera.userInteractionEnabled = NO;
    
    lo_teach_tap_static.alpha = 1.0f;
    CAKeyframeAnimation *toCameraAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    toCameraAnimation.calculationMode = kCAAnimationPaced;
    toCameraAnimation.fillMode = kCAFillModeForwards;
    toCameraAnimation.removedOnCompletion = NO;
    toCameraAnimation.duration = 2.5f;
    toCameraAnimation.repeatCount = 1; // 循环次数
    CGMutablePathRef toCamera = CGPathCreateMutable();
    CGPathMoveToPoint(toCamera, NULL, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        CGPathAddLineToPoint(toCamera, NULL, [self uiWidthBy:150.0f], [UIScreen mainScreen].bounds.size.height - ([self uiHeightBy:170.0f] + btn_vr_camera_n.size.height*3));
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        CGPathAddLineToPoint(toCamera, NULL, [self uiWidthBy:76.0f] + btn_vr_camera_n.size.width * 1.5f, [UIScreen mainScreen].bounds.size.height - [self uiHeightBy:10.0f] - btn_vr_camera_n.size.height/2);
    }
    toCameraAnimation.path = toCamera;
    CGPathRelease(toCamera);
    
    CAAnimationGroup *toCameraAnimationGroup = [CAAnimationGroup animation];
    toCameraAnimationGroup.fillMode = kCAFillModeForwards;
    toCameraAnimationGroup.removedOnCompletion = NO;
    [toCameraAnimationGroup setAnimations:[NSArray arrayWithObjects: toCameraAnimation, nil]];
    toCameraAnimationGroup.duration = 2.5f;
    toCameraAnimationGroup.delegate = self;
    [toCameraAnimationGroup setValue:@"toBird" forKey:@"toBirdCamera"];
    
    [lo_teach_tap_static.layer addAnimation:toCameraAnimationGroup forKey:@"toCamera"];
//    mModel.isTouchBirdCamera = YES;
}

- (void)onStateLeave {
    btn_bird_camera.userInteractionEnabled = NO;
    [super onStateLeave];
}

- (void)toBirdCamera {
    [lo_teachTap_animation stopAnimating];
    lo_teach_tap_static.alpha = 0.0f;
    [lo_teach_tap_static.layer removeAllAnimations];
    [mModel.photographer changeToBirdCamera:1000];
    btn_editor_camera.selected = NO;
    btn_bird_camera.selected = YES;
    [self.parentMachine changeStateTo:[States EducationChangeToEditorCamera] pushState:NO];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
//        case R_id_btn_brid_camera: {
//            [lo_teachTap_animation stopAnimating];
//            lo_teach_tap_static.alpha = 0.0f;
//            [lo_teach_tap_static.layer removeAllAnimations];
//            [mModel.photographer changeToBirdCamera:1000];
//            btn_editor_camera.selected = NO;
//            btn_bird_camera.selected = YES;
//            [self.parentMachine changeStateTo:[States EducationChangeToEditorCamera] pushState:NO];
//        }
    }
    return YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *an = [anim valueForKey:@"toBirdCamera"];
    if ([an isEqual:@"toBird"]) {
        btn_bird_camera.userInteractionEnabled = YES;
        mModel.isTouchBirdCamera = YES;
        lo_teach_tap_static.alpha = 0.0f;
        [lo_teach_tap_static.layer removeAllAnimations];
        lo_teachTap_animation.alpha = 1.0f;
        if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
            lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:100.0f];
            lo_teachTap_animation.layoutParams.marginBottom = [self uiHeightBy:136.0f] + btn_vr_camera_n.size.height*3;
            lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
        }else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
            lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:76.0f] + btn_vr_camera_n.size.width;
            lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
        }
        lo_teachTap_animation.animationDuration = 1.0;
        [lo_teachTap_animation startAnimating];
    }
}

@end
