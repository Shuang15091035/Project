//
//  InspiratedCamera.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/12.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedCamera.h"
#import "MesherModel.h"
#import <jw/CMDeviceMotion+JWCoreCategory.h>
#import <jw/UIDevice+JWCoreCategory.h>

@interface InspiratedCamera() {
    JWRelativeLayout *lo_camera;
    JWDeviceCamera *inspiratedCamera;
    
    JWRelativeLayout *lo_empty;
    JWRelativeLayout *lo_game_view;
    JWFrameLayout *lo_menu_right;
    UIView *gameView;
    CGRect rect_lo;
    CGRect rect;
    
    CMMotionManager* motionManager;
    JCQuaternion quater;
    
    UIButton *btn_shot;
    
    JWRelativeLayout *lo_prompt;
//    JCVector3 *zAxis;
}

@end

@implementation InspiratedCamera

- (UIView *)onCreateView:(UIView *)parent {
    lo_camera = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_inspirated_camera];
    lo_menu_right = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    lo_game_view = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    gameView = [parent viewWithTag:R_id_game_view];
    
    rect_lo = lo_game_view.frame;
    rect = gameView.frame;
    
    JWRelativeLayout *lo_shot = [JWRelativeLayout layout];
    lo_shot.layoutParams.width = [MesherModel uiWidthBy:180.0f];
    lo_shot.layoutParams.height = JWLayoutMatchParent;
    lo_shot.backgroundColor = [UIColor clearColor];
    lo_shot.layoutParams.alignment = JWLayoutAlignParentRight;
    [lo_camera addSubview:lo_shot];
    
    JWRelativeLayout *bg_shot = [JWRelativeLayout layout];
    bg_shot.layoutParams.width = JWLayoutMatchParent;
    bg_shot.layoutParams.height = JWLayoutMatchParent;
    bg_shot.backgroundColor = [UIColor blackColor];
    bg_shot.alpha = 0.3f;
    [lo_shot addSubview:bg_shot];
    
    UIImage *img_shot = [UIImage imageByResourceDrawable:@"btn_shot_n"];
    btn_shot = [[UIButton alloc] initWithImage:img_shot selectedImage:img_shot];
    btn_shot.layoutParams.width = JWLayoutWrapContent;
    btn_shot.layoutParams.height = JWLayoutWrapContent;
    btn_shot.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_shot addSubview:btn_shot];
    
    UIImage *img_back = [UIImage imageByResourceDrawable:@"btn_close_white"];
    UIButton *btn_back = [[UIButton alloc] initWithImage:img_back selectedImage:img_back];
    btn_back.layoutParams.width = JWLayoutWrapContent;
    btn_back.layoutParams.height = JWLayoutWrapContent;
    btn_back.layoutParams.alignment = JWLayoutAlignCenterHorizontal | JWLayoutAlignParentTop;
    btn_back.layoutParams.marginTop = [MesherModel uiWidthBy:20.0f];
    [lo_shot addSubview:btn_back];
    
    lo_prompt = [JWRelativeLayout layout];
    lo_prompt.layoutParams.width = JWLayoutWrapContent;
    lo_prompt.layoutParams.height = JWLayoutWrapContent;
    lo_prompt.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lo_prompt.backgroundColor = [UIColor clearColor];
    [lo_camera addSubview:lo_prompt];
    
//    JWRelativeLayout *lo_bg_prompt = [JWRelativeLayout layout];
//    lo_bg_prompt.layoutParams.width = 0.3;
//    lo_bg_prompt.layoutParams.height = 0.3;
//    lo_bg_prompt.backgroundColor = [UIColor ]
    
    UILabel *lv_prompt = [[UILabel alloc] init];
    lv_prompt.layoutParams.width = JWLayoutWrapContent;
    lv_prompt.layoutParams.height = JWLayoutWrapContent;
    lv_prompt.text = @"提示:暂不支持仰视";
    lv_prompt.textColor = [UIColor whiteColor];
    lv_prompt.backgroundColor = [UIColor blackColor];
    lv_prompt.labelTextSize = 15;
    [lo_prompt addSubview:lv_prompt];
    
    [btn_shot addTarget:self action:@selector(shot) forControlEvents:UIControlEventTouchUpInside];
    [btn_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    return lo_camera;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    lo_camera.hidden = NO;
    lo_prompt.hidden = YES;
    [self start];
    
    if (inspiratedCamera == nil) {
        inspiratedCamera = [[JWDeviceCamera alloc] initWithContext:mModel.currentContext parent:mModel.inspiratedCameraScene.root cameraId:@"InspiratedCameraScene"];
    }
    [mModel.inspiratedCameraScene changeCameraById:inspiratedCamera.camera.Id];
    [inspiratedCamera start];
    [mModel.world changeSceneById:mModel.inspiratedCameraScene.Id];
    [mModel.currentContext.cameraCapturer start];
    
    lo_game_view.backgroundColor = [UIColor clearColor];
    lo_game_view.layoutParams.width = JWLayoutMatchParent;
    lo_game_view.layoutParams.height = JWLayoutMatchParent;
    gameView.layoutParams.width = JWLayoutMatchParent;
    gameView.layoutParams.height = JWLayoutMatchParent;
    gameView.layoutParams.marginTop = -10;
    gameView.layoutParams.marginLeft = -10;
    gameView.layoutParams.marginBottom = -10;
    gameView.layoutParams.marginRight = -10;
}

- (void)onStateLeave {
    lo_camera.hidden = YES;
    [mModel.world changeSceneById:mModel.currentScene.Id];
    [mModel.currentContext.cameraCapturer stop];//关闭
    [inspiratedCamera stop];
    
    lo_game_view.backgroundColor = [UIColor whiteColor];
    mModel.backgroundSprite.visible = YES;
    lo_game_view.frame = rect_lo;
    gameView.frame = rect;
    gameView.layoutParams.marginTop = 10;
    gameView.layoutParams.marginLeft = 10;
    gameView.layoutParams.marginBottom = 10;
    gameView.layoutParams.marginRight = lo_menu_right.frame.size.width + 10;

    [self stop];
    
    [super onStateLeave];
}

- (void)back {
    [self.parentMachine revertState];
}

- (void)shot{
    id<JIGameEngine> engine = mModel.currentContext.engine;
    id<JIRenderTimer> renderTimer = engine.renderTimer;
    JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
    __weak id<IMesherModel> model = mModel;
    __weak typeof(self) weakSelf = self;
    listener.onSnapshot = (^(UIImage* screenshot) {
        NSLog(@"screenshot");
        model.inspiratedImage = screenshot;
        NSLog(@"%f,%f",model.inspiratedImage.size.width,model.inspiratedImage.size.height);
        InspiratedPlan *p = [mModel.project createInspiratedPlan];
        p.qw = quater.w;
        p.qx = quater.x;
        p.qy = quater.y;
        p.qz = quater.z;
        model.isInspiratedCreate = YES;
        [UIImagePNGRepresentation(screenshot) writeToFile:p.inspirateBackground.realPath atomically:YES];
        [model.project saveInspiratedPlans];
        model.currentPlan = p;
        [weakSelf stop];
        [weakSelf.parentMachine changeStateTo:[States InspiratedEdit] pushState:NO];
    });
    CGRect frame = engine.frame.view.frameInPixels;
    JCRect shotrect = JCRectMake(0.0f, 0.0f, frame.size.width-(10*[UIScreen mainScreen].scale), frame.size.height-(10*[UIScreen mainScreen].scale));
    [renderTimer snapshotByRect:shotrect async:YES listener:listener];
    [JWCoreUtils playCameraSound];
}

- (void)start {
    if (motionManager == nil) {
        motionManager = [[CMMotionManager alloc] init];
    }
    if (motionManager.deviceMotionAvailable) {
        if ([UIDevice currentDevice].type == UIDeviceTypeIPad) {
            if ([UIDevice currentDevice].ipadModel <= UIDeviceIPadModel4) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 30.0f;
            } else {
                motionManager.deviceMotionUpdateInterval = 1.0f / 60.0f;
            }
        } else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
            if ([UIDevice currentDevice].iphoneModel <= UIDeviceIPhoneModel4) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 15.0f;
            } else if ([UIDevice currentDevice].iphoneModel > UIDeviceIPhoneModel4 && [UIDevice currentDevice].iphoneModel < UIDeviceIPhoneModel5s) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 30.0f;
            } else {
                motionManager.deviceMotionUpdateInterval = 1.0f / 60.0f;
            }
        }
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            quater = [motion orientationByInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
            NSLog(@"%f,%f,%f,%f",quater.w,quater.x,quater.y,quater.z);
            JCVector3 xAxis = JCVector3Zero();
            JCVector3 yAxis = JCVector3Zero();
            JCVector3 zAxis = JCVector3Zero();
            JCQuaternionToAxes(&quater, &xAxis, &yAxis, &zAxis);
            if (zAxis.y < 0) {
                NSLog(@"up");
                [self performSelectorOnMainThread:@selector(hiddenShot) withObject:nil waitUntilDone:YES];// UI改动调回主线程改变
            }else {
                NSLog(@"down");
                [self performSelectorOnMainThread:@selector(showShot) withObject:nil waitUntilDone:YES];
            }
            
        }];
    }
}

- (void)hiddenShot {
    btn_shot.hidden = YES;
    lo_prompt.hidden = NO;
}

- (void)showShot {
    btn_shot.hidden = NO;
    lo_prompt.hidden = YES;
}

- (void)stop {
    [motionManager stopDeviceMotionUpdates];
}


@end
