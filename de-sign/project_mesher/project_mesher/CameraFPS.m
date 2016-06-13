//
//  CameraFPS.m
//  project_mesher
//
//  Created by mac zdszkj on 16/1/6.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "CameraFPS.h"
#import "MesherModel.h"
#import "GamePhotographer.h"

@interface CameraFPS ()<JWOnAnalogStickEventListener> {
    JWRelativeLayout *lo_ItemFPS;
    JWRelativeLayout *lo_game_view;
    
    JWDeviceCamera *mFPSCamera;
    JWFPSCameraPrefab *mMFPSCamera;
    JWAnalogStick *as_stick;
    NSTimer *timer;
    CGPoint mOffset;
    
    CADisplayLink* displayLink;
    id<JIGameObject> origin;
    id<JIGameObject> direction;
    
    UIButton *btn_manualSwitch;
    BOOL isPause;
    JWAnimationListener* listener;
}

@end

@implementation CameraFPS

- (UIView *)onCreateView:(UIView *)parent {
    lo_game_view = [parent viewWithTag:R_id_lo_game_view];
    
    lo_ItemFPS = [JWRelativeLayout layout];
    lo_ItemFPS.layoutParams.width = mModel.gameViewWidth;
    lo_ItemFPS.layoutParams.height = JWLayoutMatchParent;
    [parent addSubview:lo_ItemFPS];
    
    as_stick = [[JWAnalogStick alloc] init];
//    as_stick.layer.cornerRadius = 60.0f;
//    as_stick.clipsToBounds = YES;
    UIImage *border = [UIImage imageByResourceDrawable:@"control_border"];
    UIImage *ball = [UIImage imageByResourceDrawable:@"control_ball"];
    as_stick.backgroundView.image = border;
    as_stick.backgroundView.layer.cornerRadius = 60.0f;
    as_stick.backgroundView.clipsToBounds = YES;
    as_stick.backgroundView.alpha = 0.5f;
    as_stick.stickView.image = ball;
    as_stick.direction = JWAnalogStickDirectionAll;
    as_stick.backgroundColor = [UIColor clearColor];
    as_stick.layoutParams.width = JWLayoutWrapContent;
    as_stick.layoutParams.height = JWLayoutWrapContent;
    as_stick.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    as_stick.layoutParams.marginRight = 20;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        as_stick.layoutParams.marginBottom = 50;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        as_stick.layoutParams.marginBottom = 25;
    }
    [lo_ItemFPS addSubview:as_stick];

    btn_manualSwitch = (UIButton*)[parent viewWithTag:R_id_btn_fps_switch];
    [self.viewEventBinder bindEventsToView:btn_manualSwitch willBindSubviews:NO andFilter:nil];

    as_stick.listener = self;
    
    return lo_ItemFPS;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    isPause = YES;
    listener = [[JWAnimationListener alloc] init];
    
    if (btn_manualSwitch.selected) {
        [mModel.photographer changeToMFPSCamera:1000];
        as_stick.hidden = YES;
        mModel.autoFPS = NO;
        mModel.isFPS = YES;
    }else {
        mFPSCamera = [mModel.photographer changeToFPSCamera:1000];
        btn_manualSwitch.selected = NO;
        as_stick.hidden = NO;
        mModel.autoFPS = YES;
    }
    [self updateUndoRedoState];
    
    btn_manualSwitch.alpha = 1.0f;
    
    CameraFPS *weakSelf = self;
    id<IMesherModel> model = mModel;
    UIButton *btn_manualSwitch_b = btn_manualSwitch;
    mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllItems | SelectedMaskAllArchs;
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<JIGameObject> object) {
        if (object == nil) {
            return;
        }
        if (btn_manualSwitch_b.selected) {
            ItemInfo *it = [Data getItemInfoFromInstance:object];
            if (it.type == ItemTypeItem) {
                [weakSelf.parentMachine changeStateTo:[States ItemEdit]];
            } else if (it.type != ItemTypeItem) {
                model.borderObject = object;
                [weakSelf.parentMachine changeStateTo:[States ArchitureEdit]];
            }
        }else {
            return;
        }
    });
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.photographer.cameraEnabled = YES;
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(seeObject)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

}

- (void)onStateLeave {
    [timer invalidate];
    timer = nil;
//    btn_manualSwitch.alpha = 0.0f;
    [super onStateLeave];
    
}

- (void)analogStick:(JWAnalogStick *)analogStick didOffset:(CGPoint)offset {
    mOffset = offset;
    if (timer == nil) {
        timer = [NSTimer timerWithTimeInterval:0.0167f target:self selector:@selector(moveCamera) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];// 防止时间冲突
    }
    timer.fireDate = [NSDate distantPast];
}

- (void)moveCamera{
    JCVector3 offsetXAxis3 = mFPSCamera.camera.transform.xAxis;
    JCVector2 offsetXAxis = JCVector2Make(offsetXAxis3.x, offsetXAxis3.z);
    JCVector3 offsetYAxis3 = mFPSCamera.camera.transform.zAxis;
    offsetYAxis3 = JCVector3Negative(&offsetYAxis3);
    JCVector2 offsetYAxis = JCVector2Make(offsetYAxis3.x, offsetYAxis3.z);
    JCVector2 offsetX = JCVector2Muls(&offsetXAxis, mOffset.x);
    JCVector2 offsetY = JCVector2Muls(&offsetYAxis, mOffset.y);
    JCVector2 offset = JCVector2Addv(&offsetX, &offsetY);
    const float speed = 0.001f;
    offset = JCVector2Muls(&offset, speed);
    [mFPSCamera.root.transform translate:JCVector3Make(offset.x, 0.0f, offset.y)];
}

- (void)analogStickDidReset:(JWAnalogStick *)analogStick {
    // 回弹到中间触发
    timer.fireDate = [NSDate distantFuture];
}

- (void)seeObject {
    id<JIGameScene> scene = mModel.currentScene; // 获取场景
    scene.rayQuery.willSortByDistance = YES;
    JCRay3 ray = [self createRay];
    scene.rayQuery.mask = SelectedMaskAllItems;
    id<JIRayQueryResult> result = [scene.rayQuery getResultByRay:ray object:scene.root];
    if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
        JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
        id<JIGameObject> object = e.object;
        if (e.distance < 3) {
            [self AnimationPlay:object];
        }
    }else {
        for (id<JIGameObject> obj in mModel.currentPlan.objects) {
            [self AnimationRollBack:obj];
        }
    }
}


- (void)AnimationPlay:(id<JIGameObject>)object {
    id<JIAnimation> anim = [object animationForId:@"Take 001" recursive:YES];
    if (anim == nil) {
        return;
    }
    // 设置一个监听 使之动画播放完后才能执行下一步动画
    listener.onPause = (^void(id<JIAnimation> animation){
        isPause = YES;
                        });
    anim.listener = listener;
    anim.loop = NO;
    ObjectExtra *extra = object.extra;
    if (isPause) {
        if (extra.itemAnimation != nil) {
            if (!extra.itemAnimation.isOpen) {
                isPause = NO;
                extra.itemAnimation.isOpen = YES;
                object.extra = extra;
                [anim play];
            }
        }else {
            isPause = NO;
            ItemAnimation *itemAnimation = [ItemAnimation new];
            itemAnimation.isOpen = YES;
            extra.itemAnimation = itemAnimation;
            object.extra = extra;
            [anim play];
        }
    }
}

- (void)AnimationRollBack:(id<JIGameObject>)object {
    id<JIAnimation> anim = [object animationForId:@"Take 001" recursive:YES];
    if (anim == nil) {
        return;
    }
    listener.onPause = (^void(id<JIAnimation> animation){
        isPause = YES;
    });
    anim.listener = listener;
    anim.loop = NO;
    ObjectExtra *extra = object.extra;
    if (isPause) {
        if (extra.itemAnimation == nil) {
            return;
        }
        if (extra.itemAnimation.isOpen) {
            isPause = NO;
            extra.itemAnimation.isOpen = NO;
            object.extra = extra;
            [anim rollback];
        }
    }
}

- (JCRay3)createRay {
    origin = mFPSCamera.camera.host; //获取原点 VRCamera原点在host上
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

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_fps_switch: {
            btn_manualSwitch.selected = !btn_manualSwitch.selected;
            if (btn_manualSwitch.selected) {
                [mModel.photographer changeToMFPSCamera:1000];
                as_stick.hidden = YES;
                mModel.autoFPS = NO;
                mModel.isFPS = YES;
            }else {
                [mModel.photographer changeToFPSCamera:0];
                as_stick.hidden = NO;
                mModel.autoFPS = YES;
                mModel.isFPS = NO;
            }
            [self.parentMachine changeStateTo:[States CameraFPS]];
            break;
        }
    }
    return YES;
}

@end
