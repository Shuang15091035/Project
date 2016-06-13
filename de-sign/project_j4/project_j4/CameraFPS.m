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

@interface CameraFPS ()<CCVOnAnalogStickEventListener> {
    CCVRelativeLayout *lo_ItemFPS;
    CCVRelativeLayout *lo_game_view;
    
    CCVDeviceCamera* mFPSCamera;
    CCVAnalogStick *as_stick;
    NSTimer *timer;
    CGPoint mOffset;
}

@end

@implementation CameraFPS

- (UIView *)onCreateView:(UIView *)parent {
    lo_game_view = [parent viewWithTag:R_id_lo_game_view];
    
    lo_ItemFPS = [CCVRelativeLayout layout];
    lo_ItemFPS.layoutParams.width = mModel.gameViewWidth;
    lo_ItemFPS.layoutParams.height = CCVLayoutMatchParent;
    [parent addSubview:lo_ItemFPS];
    
    as_stick = [[CCVAnalogStick alloc] init];
//    as_stick.layer.cornerRadius = 60.0f;
//    as_stick.clipsToBounds = YES;
    UIImage *border = [UIImage imageByResourceDrawable:@"control_border"];
    UIImage *ball = [UIImage imageByResourceDrawable:@"control_ball"];
    as_stick.backgroundView.image = border;
    as_stick.backgroundView.layer.cornerRadius = 60.0f;
    as_stick.backgroundView.clipsToBounds = YES;
    as_stick.backgroundView.alpha = 0.5f;
    as_stick.stickView.image = ball;
    as_stick.direction = CCVAnalogStickDirectionAll;
    as_stick.backgroundColor = [UIColor clearColor];
    as_stick.layoutParams.width = CCVLayoutWrapContent;
    as_stick.layoutParams.height = CCVLayoutWrapContent;
    as_stick.layoutParams.alignment = CCVLayoutAlignParentBottomRight;
    as_stick.layoutParams.marginRight = 20;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        as_stick.layoutParams.marginBottom = 50;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        as_stick.layoutParams.marginBottom = 25;
    }
    [lo_ItemFPS addSubview:as_stick];
    as_stick.listener = self;
    
    return lo_ItemFPS;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    mFPSCamera = [mModel.photographer changeToFPSCamera:1000];
    [self updateUndoRedoState];
    
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<ICVGameObject> object) {
        if (object == nil) {
            return;
        }
//        [this.parentMachine changeStateTo:[States ItemEdit]];
    });
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.photographer.cameraEnabled = YES;

}

- (void)onStateLeave {
    [timer invalidate];
    timer = nil;
    [super onStateLeave];
    
}

- (void)analogStick:(CCVAnalogStick *)analogStick didOffset:(CGPoint)offset {
    mOffset = offset;
    if (timer == nil) {
        timer = [NSTimer timerWithTimeInterval:0.0167f target:self selector:@selector(moveCamera) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];// 防止时间冲突
    }
    timer.fireDate = [NSDate distantPast];
}

- (void)moveCamera{
    CCCVector3 offsetXAxis3 = mFPSCamera.camera.transform.xAxis;
    CCCVector2 offsetXAxis = CCCVector2Make(offsetXAxis3.x, offsetXAxis3.z);
    CCCVector3 offsetYAxis3 = mFPSCamera.camera.transform.zAxis;
    offsetYAxis3 = CCCVector3Negative(&offsetYAxis3);
    CCCVector2 offsetYAxis = CCCVector2Make(offsetYAxis3.x, offsetYAxis3.z);
    CCCVector2 offsetX = CCCVector2Muls(&offsetXAxis, mOffset.x);
    CCCVector2 offsetY = CCCVector2Muls(&offsetYAxis, mOffset.y);
    CCCVector2 offset = CCCVector2Addv(&offsetX, &offsetY);
    const float speed = 0.001f;
    offset = CCCVector2Muls(&offset, speed);
    [mFPSCamera.root.transform translateX:offset.x Y:0.0f Z:offset.y];
}

- (void)analogStickDidReset:(CCVAnalogStick *)analogStick {
    // 回弹到中间触发
    timer.fireDate = [NSDate distantFuture];
}

@end
