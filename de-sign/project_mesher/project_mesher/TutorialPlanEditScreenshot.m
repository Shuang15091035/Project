//
//  TutorialPlanEditScreenshot.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TutorialPlanEditScreenshot.h"
#import "MesherModel.h"
#import "GamePhotographer.h"

@interface TutorialPlanEditScreenshot() {
    UIImageView *btn_screenshot;
    UIImageView *lo_teach_tap_static;
    UIImageView *lo_teach_double_static;
    UIImageView *lo_teach_tap_right;
    UIImageView *lo_teachTap_animation;
    UIImageView *lo_cg;
    UIImage *img_mainMenu;
    UIImage *btn_homepage_n;
    
    JWRelativeLayout *lo_PlanEdit;
    JWFrameLayout *lo_screenshot;
    UIActivityIndicatorView *crl_loading;
    
    CAAnimationGroup *toShotAnimationGroup;
    CAKeyframeAnimation *doubleTouch;
    
    NSTimer *touchMove_sin;
    NSTimer *touchMove_dou;
    
    JWEditorCameraPrefab *camera;
    CGPoint firstPoint;
//    JWRelativeLayout *lo_empty;
    
    JWRelativeLayout *lo_edu_mov;
}

@end

@implementation TutorialPlanEditScreenshot

- (UIView *)onCreateView:(UIView *)parent {
    lo_PlanEdit = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_teach_main];
    lo_teach_tap_static = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap_static];
    lo_teach_double_static = (UIImageView*)[parent viewWithTag:R_id_lo_teach_double_static];
    lo_teach_tap_right = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap_right];
    lo_teachTap_animation = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap];
    lo_cg = (UIImageView*)[parent viewWithTag:R_id_lo_cg];
    img_mainMenu = [UIImage imageByResourceDrawable:@"bg_main_menu.png"];
    btn_homepage_n = [UIImage imageByResourceDrawable:@"btn_homepage_n"];
    btn_screenshot = (UIImageView*)[parent viewWithTag:R_id_btn_screenshot];
//    btn_screenshot.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_screenshot willBindSubviews:NO andFilter:nil];
    
#pragma mark 为了截屏做的白屏
    lo_screenshot = [JWFrameLayout layout];
    lo_screenshot.layoutParams.width = JWLayoutMatchParent;
    lo_screenshot.layoutParams.height = JWLayoutMatchParent;
    lo_screenshot.backgroundColor = [UIColor whiteColor];
    lo_screenshot.alpha = 0.5f;
    lo_screenshot.hidden = YES;
    [lo_PlanEdit addSubview:lo_screenshot];
    
    crl_loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    crl_loading.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_screenshot addSubview:crl_loading];
    
    lo_edu_mov = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_teach_mov];
    
    return nil;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    btn_screenshot.userInteractionEnabled = NO;
    lo_teach_tap_right.alpha = 1.0f;
    CAKeyframeAnimation *toShotAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    toShotAnimation.calculationMode = kCAAnimationPaced;
    toShotAnimation.fillMode = kCAFillModeForwards;
    toShotAnimation.removedOnCompletion = NO;
    toShotAnimation.duration = 2.5f;
    toShotAnimation.repeatCount = 1; // 循环次数
    CGMutablePathRef toShot = CGPathCreateMutable();
    CGPathMoveToPoint(toShot, NULL, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        CGPathAddLineToPoint(toShot, NULL, [MesherModel uiWidthBy:90.0f] + img_mainMenu.size.width/2, [MesherModel uiHeightBy:60.0f] + img_mainMenu.size.height);
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        CGPathAddLineToPoint(toShot, NULL, [MesherModel uiWidthBy:100.0f] + img_mainMenu.size.width/2, [MesherModel uiHeightBy:50.0f] + img_mainMenu.size.height);
    }
    toShotAnimation.path = toShot;
    CGPathRelease(toShot);
    toShotAnimationGroup = [CAAnimationGroup animation];
    toShotAnimationGroup.fillMode = kCAFillModeForwards;
    toShotAnimationGroup.removedOnCompletion = NO;
    [toShotAnimationGroup setAnimations:[NSArray arrayWithObjects: toShotAnimation, nil]];
    toShotAnimationGroup.duration = 2.5f;
    toShotAnimationGroup.delegate = self;
    [toShotAnimationGroup setValue:@"toShot_v" forKey:@"toShotButton"];
    
//    [lo_teach_tap_static.layer addAnimation:toShotAnimationGroup forKey:@"toShot"];
    
    firstPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    CAKeyframeAnimation *touchMove = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    touchMove.calculationMode = kCAAnimationPaced;
    touchMove.fillMode = kCAFillModeForwards;
    touchMove.removedOnCompletion = NO;
    touchMove.duration = 2.5f;
    touchMove.repeatCount = 1; // 循环次数
    CGMutablePathRef movePath = CGPathCreateMutable();
    CGPathMoveToPoint(movePath, NULL, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    CGPathAddLineToPoint(movePath, NULL, [UIScreen mainScreen].bounds.size.width/2 + 200, [UIScreen mainScreen].bounds.size.height/2);
//    CGPathAddLineToPoint(movePath, NULL, [UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2);
    touchMove.path = movePath;
    CGPathRelease(movePath);
    touchMove.delegate = self;
    [touchMove setValue:@"touchMove" forKey:@"touchMove"];
//    touchMove.autoreverses = YES;
    [lo_teach_tap_right.layer addAnimation:touchMove forKey:@"touchMove"];
    
    touchMove_sin = [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(touchTimeSingle) userInfo:nil repeats:YES];
    camera = [mModel.photographer changeToEditorCamera:0];
    
    doubleTouch = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    doubleTouch.calculationMode = kCAAnimationPaced;
    doubleTouch.fillMode = kCAFillModeForwards;
    doubleTouch.removedOnCompletion = NO;
    doubleTouch.duration = 2.5f;
    doubleTouch.repeatCount = 1; // 循环次数
    CGMutablePathRef doublePath = CGPathCreateMutable();
    CGPathMoveToPoint(doublePath, NULL, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    CGPathAddLineToPoint(doublePath, NULL, [UIScreen mainScreen].bounds.size.width/2 + 200, [UIScreen mainScreen].bounds.size.height/2);
    //    CGPathAddLineToPoint(movePath, NULL, [UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2);
    doubleTouch.path = doublePath;
    CGPathRelease(doublePath);
    doubleTouch.delegate = self;
    [doubleTouch setValue:@"touchMoveDouble" forKey:@"touchMoveDouble"];
    
}

- (void) touchTimeSingle {
    lo_edu_mov.hidden = NO;
    CALayer *moveTeachLayer = [lo_teach_tap_right.layer presentationLayer];//要从所有layer中取出有用的layer
    CGPoint p = moveTeachLayer.position;//[[UIScreen mainScreen] pointInPixelsByPoint:moveTeachLayer.position];
    [camera move1dx:-(p.x-firstPoint.x) dy:-(p.y-firstPoint.y)];
    firstPoint = p;
}

- (void) touchTimeDouble {
    CALayer *moveTeachLayer = [lo_teach_double_static.layer presentationLayer];//要从所有layer中取出有用的layer
    CGPoint p = moveTeachLayer.position;//[[UIScreen mainScreen] pointInPixelsByPoint:moveTeachLayer.position];
    [camera move2dx:-(p.x-firstPoint.x) dy:-(p.y-firstPoint.y)];
    firstPoint = p;
}

- (void)onStateLeave {
    touchMove_sin = nil;
    touchMove_dou = nil;
    toShotAnimationGroup = nil;
    doubleTouch = nil;
    btn_screenshot.userInteractionEnabled = NO;
    [super onStateLeave];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.view.tag) {
        case R_id_btn_screenshot: {
            [lo_teachTap_animation stopAnimating];
            lo_teach_tap_static.alpha = 0.0f;
            [lo_teach_tap_static.layer removeAllAnimations];
            lo_teach_tap_right.alpha = 0.0f;
            [lo_teach_tap_right.layer removeAllAnimations];
            mModel.isTouchShot = NO;
            lo_teachTap_animation.alpha = 1.0f;
            lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentTopLeft;
            if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
                lo_teachTap_animation.layoutParams.marginTop= [MesherModel uiHeightBy:40.0f] + btn_homepage_n.size.height;
                lo_teachTap_animation.layoutParams.marginLeft = [MesherModel uiWidthBy:40.0f] + img_mainMenu.size.width/2;
            }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
                lo_teachTap_animation.layoutParams.marginTop= [MesherModel uiHeightBy:30.0f] + btn_homepage_n.size.height;
                lo_teachTap_animation.layoutParams.marginLeft = [MesherModel uiWidthBy:40.0f] + img_mainMenu.size.width/2;
            }
            [lo_teachTap_animation startAnimating];
            id<JIGameEngine> engine = mModel.currentContext.engine;
            id<JIRenderTimer> renderTimer = engine.renderTimer;
            JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                NSLog(@"screenshot");
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
                lo_screenshot.hidden = YES;
                [crl_loading stopAnimating];
                [self.parentMachine changeStateTo:[States EducationEnd] pushState:NO];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            JCRect rect = JCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            lo_screenshot.hidden = NO;
            [crl_loading startAnimating];
            [renderTimer snapshotByRect:rect async:YES listener:listener];
            [JWCoreUtils playCameraSound];
            break;
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *an = [anim valueForKey:@"toShotButton"];
    if ([an isEqual:@"toShot_v"]) {
        if (flag) {
            btn_screenshot.userInteractionEnabled = YES;
        }
        mModel.isTouchHome = YES;
        mModel.completedTeach = YES;
        lo_teach_tap_static.alpha = 0.0f;
        [lo_teach_tap_static.layer removeAllAnimations];
        lo_teachTap_animation.alpha = 1.0f;
        lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentTopLeft;
        if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
            lo_teachTap_animation.layoutParams.marginTop = [MesherModel uiHeightBy:50.0f] + img_mainMenu.size.height - btn_homepage_n.size.height/2;
            lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:100.0f];
        }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
            lo_teachTap_animation.layoutParams.marginTop = [MesherModel uiHeightBy:5.0f] + img_mainMenu.size.height - btn_homepage_n.size.height/2;
            lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:120.0f];
        }
        [lo_teachTap_animation startAnimating];
    }
    NSString *an_move = [anim valueForKey:@"touchMove"];
    if ([an_move isEqual:@"touchMove"]) {
        [touchMove_sin invalidate];
        
        [UIView animateWithDuration:1.0 animations:^{ // 类方法实现UIView的动画效果
            lo_teach_tap_right.alpha = 0.0f;
        } completion:^(BOOL finished) {
            lo_teach_double_static.alpha = 1.0f;
            [lo_teach_tap_right.layer removeAllAnimations];
            [lo_teach_double_static.layer removeAllAnimations];
            [lo_teach_double_static.layer addAnimation:doubleTouch forKey:@"double"];
            firstPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            touchMove_dou = [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(touchTimeDouble) userInfo:nil repeats:YES];
        }];
    }
    NSString *an_doubleMove = [anim valueForKey:@"touchMoveDouble"];
    if ([an_doubleMove isEqual:@"touchMoveDouble"]) {
        [touchMove_dou invalidate];
        
        [UIView animateWithDuration:1.0 animations:^{ // 类方法实现UIView的动画效果
            lo_teach_double_static.alpha = 0.0f;
        } completion:^(BOOL finished) {
            lo_edu_mov.hidden = YES;
            lo_teach_tap_static.alpha = 1.0f;
            [lo_teach_double_static.layer removeAllAnimations];
            [lo_teach_tap_static.layer removeAllAnimations];
            [lo_teach_tap_static.layer addAnimation:toShotAnimationGroup forKey:@"toShot"];
        }];
    }
}

@end
