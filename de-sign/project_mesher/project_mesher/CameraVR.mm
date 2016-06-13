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
#import <CoreBluetooth/CoreBluetooth.h>
#import "ItemAnimation.h"

@interface CameraVR () <CBCentralManagerDelegate>{
    JWRelativeLayout *lo_CameraVR;
    JWFrameLayout *lo_menu_right;
    CGRect rect_lo;
    CGRect rect;
    
    JWRelativeLayout *lo_mainMenu1_container; // 左上角胶囊型菜单容器
    JWLinearLayout *lo_camera; // camera容器
    
    JWVRDeviceCamera* mVRCamera;
    CGPoint mOffset;
    NSTimer *timer;
    
    CADisplayLink* displayLink;
    id<JIGameObject> origin;
    id<JIGameObject> direction;
    
    id<JIGamepad> mGamepad;
    CBCentralManager* mCentralManager;
}

@end

@implementation CameraVR

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

- (UIView *)onCreateView:(UIView *)parent {
    rect_lo = mModel.lo_game_view.frame;
    rect = mModel.gameView.frame;
    lo_menu_right = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    lo_mainMenu1_container = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_mainMenu1_container];
    lo_camera = (JWLinearLayout*)[parent viewWithTag:R_id_lo_camera];
    
    lo_CameraVR = [JWRelativeLayout layout];
    lo_CameraVR.layoutParams.width = JWLayoutMatchParent;
    lo_CameraVR.layoutParams.height = JWLayoutMatchParent;
    [parent addSubview:lo_CameraVR];
    lo_CameraVR.clickable = YES;
    [self.viewEventBinder bindEventsToView:lo_CameraVR willBindSubviews:NO andFilter:nil];
    
    UIImage *btn_close_white = [UIImage imageByResourceDrawable:@"btn_close_white"];
    UIButton *btn_close = [[UIButton alloc] initWithImage:btn_close_white selectedImage:btn_close_white];
    btn_close.layoutParams.width = JWLayoutWrapContent;
    btn_close.layoutParams.height = JWLayoutWrapContent;
    btn_close.layoutParams.alignment = JWLayoutAlignParentTopRight;
    btn_close.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
    btn_close.layoutParams.marginRight = [MesherModel uiWidthBy:20.0f];
    [lo_CameraVR addSubview:btn_close];
    [btn_close addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    return lo_CameraVR;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    
//    JWMojingPlugin* mp = mModel.currentContext.engine.pluginSystem.renderPlugin;
//    [mp enterWorldBy:MojingType4];
    NSLog(@"%@",mModel.world.currentScene.Id);
    
    mCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(seeObject)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    lo_mainMenu1_container.hidden = YES;
    lo_camera.hidden = YES;
    lo_menu_right.hidden = YES;
    
    mModel.lo_game_view.layoutParams.width = JWLayoutMatchParent;
    mModel.lo_game_view.layoutParams.height = JWLayoutMatchParent;
    mModel.gameView.layoutParams.width = JWLayoutMatchParent;
    mModel.gameView.layoutParams.height = JWLayoutMatchParent;
    mModel.gameView.layoutParams.marginTop = 0;
    mModel.gameView.layoutParams.marginLeft = 0;
    mModel.gameView.layoutParams.marginBottom = 0;
    mModel.gameView.layoutParams.marginRight = 0;

    mVRCamera = [mModel.photographer changeToVRCamera:1000];
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.photographer.cameraEnabled = YES;
    
    [mModel.currentContext.engine.gamepadManager startScan:^(id<JIGamepad> gamepad) {
        mGamepad = gamepad;
    }];
    [[JWMojingManager instance] changeMojingType:mModel.mojingType];
    if (mModel.mojingType == MojingType2 || mModel.mojingType == MojingTypeXiaoD) {
        [JWMojingManager instance].MSAALevel = 0;
    } else {
        [JWMojingManager instance].MSAALevel = 4;
        mModel.currentContext.engine.pluginSystem.renderPlugin.MSAA = 0;
    }
//    [[JWMojingManager instance] changeMojingType:MojingType4];

    id<JIBehaviour> b = [JWBehaviour behaviourWithContext:mModel.currentContext];
    b.onGamepad = ^(id<JIGamepad> gamepad) {
        if (gamepad.event == JWGamepadEventAxisValueChanged) {
            //JWGamepadAxis axis = gamepad.axis; //轴
            JCVector2 axisOffset = gamepad.axisOffset;
            mOffset = CGPointMake(axisOffset.x, axisOffset.y);
        } else if (gamepad.event == JWGamepadEventKeyUp) {
            switch (gamepad.key) {
                case JWGamepadKeyBack: {
                    id<JIGameEngine> engine = mModel.currentContext.engine;
                    id<JIRenderTimer> renderTimer = engine.renderTimer;
                    JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
                    listener.onSnapshot = (^(UIImage* screenshot) {
                        NSLog(@"VRscreenshot");
                        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
                    });
                    CGRect frame = engine.frame.view.frameInPixels;
                    JCRect screenshotRect = JCRectMake(0.0f, 0.0f, frame.size.width-(10*[UIScreen mainScreen].scale), frame.size.height-(10*[UIScreen mainScreen].scale));
                    [renderTimer snapshotByRect:screenshotRect async:YES listener:listener];
                    [JWCoreUtils playCameraSound];
                    break;
                }
                case JWGamepadKeyOk: {
                    id<JIGameScene> scene = mModel.currentScene; // 获取场景
                    //                scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                    //                JCRay3 ray = [self createRay];
                    //                scene.rayQuery.mask = [MesherModel CanSelectMask];
                    id<JIGameObject> hitBox = mVRCamera.camera.host;
                    JCVector3 min = JCVector3Make(-2.0, -2.0, -2.0);
                    JCVector3 max = JCVector3Make(2.0, 2.0, 0.0);
                    // X轴控制左右距离 Y轴控制上下距离 Z轴控制前后距离
                    JCBounds3 hitBoxBounds = JCBounds3Make(JCBoundsExtentFinite, min, max);
                    [hitBox setBounds:hitBoxBounds];
                    scene.boundsQuery.mask = SelectedMaskAllItems;
                    //                id<JIRayQueryResult> result = [scene.rayQuery getResultByRay:ray object:scene.root];// 射线和场景求交
                    id<JIBoundsQueryResult> result = [scene.boundsQuery getResultByBounds:hitBox.transformBounds object:scene.root];// 判断碰撞到的Bounds
                    if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件)
                        //                    JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
                        //                    id<JIGameObject> object = e.object;
                        //                    if (e.distance < 2.5) {
                        //                        [self AnimationSwitch:object];
                        //                    }
                        //NSLog(@"选中:%@", object.Id);
                        for (JWBoundsQueryResultEntry* boundsQ in result.entries) {
                            [self AnimationSwitch:boundsQ.object];
                        }
                    }
                    break;
                }
                    default:
                    break;
            }
        } else if (gamepad.event == JWGamepadEventKeyDown) {
            switch (gamepad.key) {
                case JWGamepadKeyLeft:
                case JWGamepadKeyUp: {
                    if (timer == nil) {
                        timer = [NSTimer timerWithTimeInterval:0.0167f target:self selector:@selector(moveCamera) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];// 防止时间冲突
                    }
                    timer.fireDate = [NSDate distantPast];
                    break;
                }
                    default:
                    break;
            }
        }
    };
    [mVRCamera.camera.host addComponent:b];
    
    mCentralManager = nil;

}

- (void)moveCamera{
    JCVector3 offsetXAxis3 = mVRCamera.camera.transform.xAxis;
    JCVector2 offsetXAxis = JCVector2Make(offsetXAxis3.x, offsetXAxis3.z);
    JCVector3 offsetYAxis3 = mVRCamera.camera.transform.zAxis;
    offsetYAxis3 = JCVector3Negative(&offsetYAxis3);
    JCVector2 offsetYAxis = JCVector2Make(offsetYAxis3.x, offsetYAxis3.z);
    JCVector2 offsetX = JCVector2Muls(&offsetXAxis, mOffset.x);
    JCVector2 offsetY = JCVector2Muls(&offsetYAxis, mOffset.y);
    JCVector2 offset = JCVector2Addv(&offsetX, &offsetY);
    const float speed = 0.05f;
    offset = JCVector2Muls(&offset, speed);
    [mVRCamera.root.transform translate:JCVector3Make(offset.x, 0.0f, offset.y)];
}

- (void)onStateLeave {
//    [[MojingGamepad sharedGamepad] stopScan];
//    [[MojingGamepad sharedGamepad] disconnect];
    if (mModel.mojingType == MojingType2 || mModel.mojingType == MojingTypeXiaoD) {
        // TODO
    } else {
        [JWMojingManager instance].MSAALevel = 0;
        mModel.currentContext.engine.pluginSystem.renderPlugin.MSAA = 4;
    }
    [[JWMojingManager instance] changeMojingType:MojingTypeUnknown];
    [mGamepad disconnect]; // 移除
    [mModel.currentContext.engine.gamepadManager stopScan]; // 停止扫描
    
    [timer invalidate];
    timer = nil;
    [displayLink invalidate];
    displayLink = nil;
    [super onStateLeave];
}

- (void)back:(id)sender {
    mModel.lo_game_view.frame = rect_lo;
    mModel.gameView.frame = rect;
    mModel.gameView.layoutParams.marginTop = 10;
    mModel.gameView.layoutParams.marginLeft = 10;
    mModel.gameView.layoutParams.marginBottom = 10;
    mModel.gameView.layoutParams.marginRight = lo_menu_right.frame.size.width + 10;
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

- (void)seeObject{
    id<JIGameScene> scene = mModel.currentScene; // 获取场景
    
//    id<JIGameObject> hitBox = mVRCamera.camera.host;
//    JCVector3 min = JCVector3Make(-1.5, -2.0, -2.0);
//    JCVector3 max = JCVector3Make(1.5, 2.0, 0.0);
//    // X轴控制左右距离 Y轴控制上下距离 Z轴控制前后距离
//    JCBounds3 hitBoxBounds = JCBounds3Make(JCBoundsExtentFinite, min, max);
//    [hitBox setBounds:hitBoxBounds];
//    scene.boundsQuery.mask = [MesherModel CanSelectMask];
//    id<JIBoundsQueryResult> result = [scene.boundsQuery getResultByBounds:hitBox.transformBounds object:scene.root];
//    if (result.numEntries > 0) {
//        for (JWBoundsQueryResultEntry* boundsQ in result.entries) {
//            [self AnimationPlay:boundsQ.object];
//        }
    
    scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
    JCRay3 ray = [self createRay];
    scene.rayQuery.mask = SelectedMaskAllItems;
    id<JIRayQueryResult> result = [scene.rayQuery getResultByRay:ray object:scene.root];// 射线和场景求交
    if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
        JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
        id<JIGameObject> object = e.object;
        if (e.distance < 1.5) {
            [self AnimationPlay:object];
        }
    }
}

#pragma mark 创造射线逻辑
- (JCRay3)createRay {
    origin = mVRCamera.camera.host; //获取原点 VRCamera原点在host上
    if (direction == nil) {
        // 创建结束点(临时点)用于完成射线方向
        direction = [mModel.currentContext createObject];
        direction.parent = origin; // 挂到原点上
        [direction.transform translate:JCVector3Make(0.0, 0.0, -1.0)]; // 防止在负Z轴1单位距离的地方 方便计算方向
    }
    JCVector3 originPosition = [origin.transform positionInSpace:JWTransformSpaceWorld];// 获取原点在世界坐标系的位置
    JCVector3 tempPosition = [direction.transform positionInSpace:JWTransformSpaceWorld];// 获取临时点在世界坐标系的位置
    JCVector3 directionPosition = JCVector3Subv(&tempPosition, &originPosition);// 计算方向
    JCRay3 ray = JCRay3Make(originPosition, directionPosition);// 创建射线
    return ray;
}

- (void)AnimationPlay:(id<JIGameObject>)object{
    id<JIAnimation> anim = [object animationForId:@"Take 001" recursive:YES];
    if (anim == nil) {
        return;
    }
    ObjectExtra *extra = object.extra;
    if (extra.itemAnimation == nil) {
        ItemAnimation *itemAnimation = [ItemAnimation new];
        itemAnimation.isFirst = NO;
        itemAnimation.isOpen = YES;
        extra.itemAnimation = itemAnimation;
        object.extra = extra;
        anim.loop = NO;
        [anim play];
    }
}

- (void)AnimationSwitch:(id<JIGameObject>)object{
    id<JIAnimation> anim = [object animationForId:@"Take 001" recursive:YES];
    if (anim == nil) {
        return;
    }
    ObjectExtra *extra = object.extra;
    if (extra.itemAnimation == nil) {
        return;
    }
    ItemAnimation *itemAnimation = extra.itemAnimation;
    if (itemAnimation.isOpen) {
        anim.loop = NO;
        [anim play];
        itemAnimation.isOpen = NO;
        extra.itemAnimation = itemAnimation;
        object.extra = extra;
    }else {
        anim.loop = NO;
        [anim rollback];
        NSLog(@"back");
        itemAnimation.isOpen = YES;
        extra.itemAnimation = itemAnimation;
        object.extra = extra;
    }
}

@end
