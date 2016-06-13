//
//  CameraVR.m
//  project_mesher
//
//  Created by mac zdszkj on 16/1/26.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "CameraVR.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import <MojingSDK/MojingGamepad.h>
#import <MojingSDK/MojingIOSAPI.h>
#import <MojingSDK/MojingKeyCode.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CameraVR () <CBCentralManagerDelegate>{
    CCVRelativeLayout *lo_CameraVR;
    CCVFrameLayout *lo_menu_right;
    CGRect rect_lo;
    CGRect rect;
    
    CCVRelativeLayout *lo_mainMenu1_container; // 左上角胶囊型菜单容器
    CCVLinearLayout *lo_camera; // camera容器
    
    CCVDeviceCamera* mVRCamera;
    CGPoint mOffset;
    NSTimer *timer;
}

@end

@implementation CameraVR

- (UIView *)onCreateView:(UIView *)parent {
    rect_lo = mModel.lo_game_view.frame;
    rect = mModel.gameView.frame;
    lo_menu_right = (CCVFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    lo_mainMenu1_container = (CCVRelativeLayout*)[parent viewWithTag:R_id_lo_mainMenu1_container];
    lo_camera = (CCVLinearLayout*)[parent viewWithTag:R_id_lo_camera];
    
    lo_CameraVR = [CCVRelativeLayout layout];
    lo_CameraVR.layoutParams.width = CCVLayoutMatchParent;
    lo_CameraVR.layoutParams.height = CCVLayoutMatchParent;
    [parent addSubview:lo_CameraVR];
    lo_CameraVR.clickable = YES;
    [self.viewEventBinder bindEventsToView:lo_CameraVR willBindSubviews:NO andFilter:nil];
    
    UIImage *btn_close_white = [UIImage imageByResourceDrawable:@"btn_close_white"];
    UIButton *btn_close = [[UIButton alloc] initWithImage:btn_close_white selectedImage:btn_close_white];
    btn_close.layoutParams.width = CCVLayoutWrapContent;
    btn_close.layoutParams.height = CCVLayoutWrapContent;
    btn_close.layoutParams.alignment = CCVLayoutAlignParentTopRight;
    btn_close.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
    btn_close.layoutParams.marginRight = [MesherModel uiWidthBy:20.0f];
    [lo_CameraVR addSubview:btn_close];
    [btn_close addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    return lo_CameraVR;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
  
    CBCentralManager * central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    lo_mainMenu1_container.hidden = YES;
    lo_camera.hidden = YES;
    lo_menu_right.hidden = YES;
    
    mModel.lo_game_view.layoutParams.width = CCVLayoutMatchParent;
    mModel.lo_game_view.layoutParams.height = CCVLayoutMatchParent;
    mModel.gameView.layoutParams.width = CCVLayoutMatchParent;
    mModel.gameView.layoutParams.height = CCVLayoutMatchParent;
//    mModel.gameView.layoutParams.marginTop = -10;
//    mModel.gameView.layoutParams.marginLeft = -10;
//    mModel.gameView.layoutParams.marginBottom = -10;
//    mModel.gameView.layoutParams.marginRight = -10;

    mVRCamera = [mModel.photographer changeToVRCamera:10000];
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.photographer.cameraEnabled = YES;
    
    [[MojingGamepad sharedGamepad] scan];
    [MojingGamepad sharedGamepad].axisValueChangedHandler = ^(NSString* peripheralName, AXIS_GAMEPAD axisID, float xValue, float yValue){
        NSLog(@"摇杆[Pad ID=%d]坐标: (%f, %f)", axisID, xValue, yValue);
        mOffset = CGPointMake(xValue, yValue);
    };
    
    [MojingGamepad sharedGamepad].buttonValueChangedHandler = ^void(NSString* peripheralName,AXIS_GAMEPAD axisID, KEY_GAMEPAD keyID, BOOL pressed){
        switch (keyID) {
            case KEY_LEFT:
            case KEY_UP:
                if (timer == nil) {
                    timer = [NSTimer timerWithTimeInterval:0.0167f target:self selector:@selector(moveCamera) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];// 防止时间冲突
                }
                timer.fireDate = [NSDate distantPast];
                break;
            case KEY_BACK:
                [self back:nil];
                NSLog(@"back");
                break;
            case KEY_OK: {
                id<ICVGameEngine> engine = mModel.currentContext.engine;
                id<ICVRenderTimer> renderTimer = engine.renderTimer;
                CCVOnSnapshotListener* listener = [[CCVOnSnapshotListener alloc] init];
                listener.onSnapshot = (^(UIImage* screenshot) {
                    NSLog(@"VRscreenshot");
                    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
                });
                CGRect frame = engine.frame.view.frameInPixels;
                CCCRect screenshotRect = CCCRectMake(0.0f, 0.0f, frame.size.width-(10*[UIScreen mainScreen].scale), frame.size.height-(10*[UIScreen mainScreen].scale));
                [renderTimer snapshotByRect:screenshotRect async:YES listener:listener];
                [CCVCoreUtils playCameraSound];
                break;
            }
            default:
                break;
        }
    };
}

- (void)moveCamera{
    CCCVector3 offsetXAxis3 = mVRCamera.camera.transform.xAxis;
    CCCVector2 offsetXAxis = CCCVector2Make(offsetXAxis3.x, offsetXAxis3.z);
    CCCVector3 offsetYAxis3 = mVRCamera.camera.transform.zAxis;
    offsetYAxis3 = CCCVector3Negative(&offsetYAxis3);
    CCCVector2 offsetYAxis = CCCVector2Make(offsetYAxis3.x, offsetYAxis3.z);
    CCCVector2 offsetX = CCCVector2Muls(&offsetXAxis, mOffset.x);
    CCCVector2 offsetY = CCCVector2Muls(&offsetYAxis, mOffset.y);
    CCCVector2 offset = CCCVector2Addv(&offsetX, &offsetY);
    const float speed = 0.05f;
    offset = CCCVector2Muls(&offset, speed);
    [mVRCamera.root.transform translateX:offset.x Y:0.0f Z:offset.y];
}

- (void)onStateLeave {
    [[MojingGamepad sharedGamepad] stopScan];
    [[MojingGamepad sharedGamepad] disconnect];
    [timer invalidate];
    timer = nil;
    [super onStateLeave];
}

- (void)back:(id)sender {
    mModel.lo_game_view.frame = rect_lo;
    mModel.gameView.frame = rect;
//    mModel.gameView.layoutParams.marginTop = 10;
//    mModel.gameView.layoutParams.marginLeft = 10;
//    mModel.gameView.layoutParams.marginBottom = 10;
//    mModel.gameView.layoutParams.marginRight = lo_menu_right.frame.size.width + 10;
    lo_mainMenu1_container.hidden = NO;
    lo_camera.hidden = NO;
    lo_menu_right.hidden = NO;
    [mVRCamera stop];
    [mModel.photographer changeToEditorCamera:1000];
    [self.parentMachine revertState];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_lo_camera:{
            break;
        }
    }
    return YES;
}

@end
