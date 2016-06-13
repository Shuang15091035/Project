//
//  ItemAR.m
//  project_mesher
//
//  Created by mac zdszkj on 15/12/1.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemAR.h"
#import "MesherModel.h"
#import "GamePhotographer.h"

@interface ItemAR () <UIGestureRecognizerDelegate> {
    CCVRelativeLayout *lo_empty;
//    CCVCameraView *cv_item_AR;
    CCVRelativeLayout *lo_game_view;
    CCVFrameLayout *lo_menu_right;
    UIView *gameView;
    CGRect rect_lo;
    CGRect rect;
    CCVDeviceCamera *arCamera;
    
    UIButton *btn_left;
    UIButton *btn_right;
    NSTimer *rotate_timer_left;
    NSTimer *rotate_timer_right;
    
    CCCVector3 oldPosition;
    CCCVector3 newPosition;
    
    CCCColor arRimColor;
    int arRimColorCount;
}

@end

@implementation ItemAR

- (UIView *)onCreateView:(UIView *)parent {
    
//    cv_item_AR = (CCVCameraView*)[parent viewWithTag:R_id_camera_view];
    lo_empty = (CCVRelativeLayout*)[parent viewWithTag:R_id_lo_empty];
    lo_menu_right = (CCVFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    
    UIImage *btn_close_white = [UIImage imageByResourceDrawable:@"btn_close_white"];
    UIButton *btn_close = [[UIButton alloc] initWithImage:btn_close_white selectedImage:btn_close_white];
    btn_close.layoutParams.width = CCVLayoutWrapContent;
    btn_close.layoutParams.height = CCVLayoutWrapContent;
    btn_close.layoutParams.alignment = CCVLayoutAlignParentTopRight;
    btn_close.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
    btn_close.layoutParams.marginRight = [MesherModel uiWidthBy:20.0f];
    [lo_empty addSubview:btn_close];
    [btn_close addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btn_screenshot_p = [UIImage imageByResourceDrawable:@"btn_screenAR"];
    UIImageView *btn_screenshot = [[UIImageView alloc] initWithImage:btn_screenshot_p];
    btn_screenshot.tag = R_id_btn_screenshot;
    btn_screenshot.layoutParams.width = CCVLayoutWrapContent;
    btn_screenshot.layoutParams.height = CCVLayoutWrapContent;
    btn_screenshot.layoutParams.alignment = CCVLayoutAlignParentRight | CCVLayoutAlignCenterVertical;
    btn_screenshot.layoutParams.marginRight = [MesherModel uiWidthBy:80.0f];
    [lo_empty addSubview:btn_screenshot];
    
    lo_empty.clickable = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [lo_empty addGestureRecognizer:pan];
    
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypePinch toView:lo_empty willBindSubviews:NO andFilter:nil];
    
    UIRotationGestureRecognizer * rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [lo_empty addGestureRecognizer:rotate];
    
    //    [self.gestureEventBinder.lastPinchGestureRecognizerrotate requireGestureRecognizerToFail:rotate];
    
    lo_game_view = (CCVRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    gameView = [parent viewWithTag:R_id_game_view];
    
    
    rect_lo = lo_game_view.frame;
    rect = gameView.frame;
    
    UIImage *bg_right = [UIImage imageByResourceDrawable:@"bg_ar_right"];
    btn_right = [[UIButton alloc] init];
    btn_right.tag = R_id_AR_right;
    [btn_right setImage:bg_right forState:UIControlStateNormal];
    btn_right.alpha = 0.5f;
    btn_right.layoutParams.width = CCVLayoutWrapContent;
    btn_right.layoutParams.height = CCVLayoutWrapContent;
    btn_right.layoutParams.alignment = CCVLayoutAlignParentBottomRight;
    btn_right.layoutParams.marginRight = [MesherModel uiWidthBy:150.0f];
    btn_right.layoutParams.marginBottom = [MesherModel uiHeightBy:200.0f];
    [lo_empty addSubview:btn_right];
    
    UIImage *bg_left = [UIImage imageByResourceDrawable:@"bg_ar_left"];
    btn_left = [[UIButton alloc] init];
    btn_left.tag = R_id_AR_left;
    [btn_left setImage:bg_left forState:UIControlStateNormal];
    btn_left.alpha = 0.5f;
    btn_left.layoutParams.width = CCVLayoutWrapContent;
    btn_left.layoutParams.height = CCVLayoutWrapContent;
    btn_left.layoutParams.alignment = CCVLayoutAlignParentBottomLeft;
    btn_left.layoutParams.marginLeft = [MesherModel uiWidthBy:150.0f];
    btn_left.layoutParams.marginBottom = [MesherModel uiHeightBy:200.0f];
    [lo_empty addSubview:btn_left];
    
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeSingleTap toView:btn_right willBindSubviews:NO andFilter:nil];
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeSingleTap toView:btn_left willBindSubviews:NO andFilter:nil];
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeLongPress toView:btn_right willBindSubviews:NO andFilter:nil];
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeLongPress toView:btn_left willBindSubviews:NO andFilter:nil];
    
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.delegate = self;
    [btn_left addGestureRecognizer:singleTapGestureRecognizer];
    [btn_right addGestureRecognizer:singleTapGestureRecognizer];
    btn_screenshot.userInteractionEnabled = YES;
    [btn_screenshot addGestureRecognizer:singleTapGestureRecognizer];
    
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.5f;
    longPressGestureRecognizer.delegate = self;
    [btn_left addGestureRecognizer:longPressGestureRecognizer];
    [btn_right addGestureRecognizer:longPressGestureRecognizer];
    
    [singleTapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
    
    return lo_empty;
}

- (void)onDestroy {
    if ([rotate_timer_left isValid]) {
        [rotate_timer_left invalidate];
        rotate_timer_left = nil;
    }
    if ([rotate_timer_right isValid]) {
        [rotate_timer_right invalidate];
        rotate_timer_right = nil;
    }
    [super onDestroy];
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    
    // 把之前场景的对象传入当前场景
    mModel.arObject = [mModel.selectedObject copyInstanceUsingFilter:^BOOL(id<ICVGameObject> object, id<ICVComponent> component) {
        ItemInfo *info = [Data getItemInfoFromInstance:object];
        if (info.isOverlap) {
            [mModel.currentPlan hidedDecals:object];
        }
        if (object == mModel.itemRectFrameDecals.decalsObject) {
            return NO;
        }
        return YES;
    } withPrefix:nil];
    
    arRimColorCount = 0;
    arRimColor = CCCColorNull();
    [self enumChildrenUsing:mModel.arObject];
    arRimColor.r /= arRimColorCount;
    arRimColor.g /= arRimColorCount;
    arRimColor.b /= arRimColorCount;
    arRimColor.a /= arRimColorCount;
    if (arRimColorCount == 0 || CCCColorIsNull(&arRimColor)) {
        arRimColor = CCCColorMake(0.5, 0.5, 0.5, 1.0);
    }
    mModel.arVideoMaterial.outlineColor = arRimColor;
    
    if (arCamera == nil) {
        arCamera = [[CCVDeviceCamera alloc] initWithContext:mModel.currentContext parent:mModel.arScene.root cameraId:@"ArCamera"];
    }
    [mModel.arScene changeCameraById:arCamera.camera.Id];
    [arCamera start];
    [mModel.world changeSceneById:mModel.arScene.Id]; // world跳转到arScene
    //mModel.arScene.clearColor = CCCColorTransparent();
    mModel.arScene.clearColor = CCCColorMake(0.1f, 0.1f, 0.1f, 0.1f); // TODO 先这样实现阴影的显示
    
    lo_empty.hidden = NO;
//    [cv_item_AR startCamera];
    [mModel.currentContext.cameraCapturer start];//开启
    
    mModel.arObject.parent = mModel.arScene.root; // 改变物件根节点 放到不同的场景中
    //[mModel.arObject.transform reset:NO]; // YES是把所有子对象归零
    [mModel.arObject.transform setPositionV:CCCVector3Zero()];
    [mModel.arObject.transform resetOrientation:NO];
    [mModel.arObject.transform translateX:0.0f Y:0.0f Z:-2.0f];
    [mModel.arObject.transform yawDegrees:180.0f];
    
    lo_game_view.backgroundColor = [UIColor clearColor];
}

- (void)enumChildrenUsing:(id<ICVGameObject>)obj {
    [obj.transform enumChildrenUsing:^(id<ICVTransform> child, NSUInteger idx, BOOL *stop) {
        id<ICVGameObject> childObj = child.host; //host表示transform的属于者
        if (childObj.renderable != nil) {
            if ([childObj.renderable conformsToProtocol:@protocol(ICVMeshRenderer)]){
                id<ICVMeshRenderer> meshRenderer = (id<ICVMeshRenderer>)childObj.renderable;
                CCCColor rimColor = meshRenderer.material.rimColor;
                float rimPower = meshRenderer.material.rimPower;
                if(!CCCColorIsNull(&rimColor)) {
                    arRimColor.r += powf(rimColor.r, rimPower);
                    arRimColor.g += powf(rimColor.g, rimPower);
                    arRimColor.b += powf(rimColor.b, rimPower);
                    arRimColor.a += powf(rimColor.a, rimPower);
                    arRimColorCount++;
                }
            }
        }
        [self enumChildrenUsing:childObj];
    }];
}

- (void)onStateLeave {
    [rotate_timer_left invalidate];
    [rotate_timer_right invalidate];
    lo_empty.hidden = YES;
//    [cv_item_AR stopCamera];
    [mModel.currentContext.cameraCapturer stop];//关闭
    [arCamera stop];
    lo_game_view.backgroundColor = [UIColor whiteColor];
    mModel.backgroundSprite.visible = YES;
    mModel.photographer.cameraEnabled = NO;
    [mModel.world changeSceneById:mModel.currentScene.Id];
    
    [CCVCoreUtils destroyObject:mModel.arObject]; // 离开时先把object删除
    mModel.arObject = nil; // 然后附空
    
    [super onStateLeave];
}

- (void)back:(id)sender {
    ItemInfo *info = [Data getItemInfoFromInstance:mModel.selectedObject];
    if (info.isOverlap) {
        [mModel.currentPlan addDecalsToObject:mModel.selectedObject];
    }
    [self.parentMachine revertState];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint p = pan.positionInPixels;
            CCCRayPlaneIntersectResult result = [mModel.arScene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];
            if (result.hit) {
                newPosition = result.point;
                [mModel.arObject.transform setPositionV:newPosition inSpace:CCVTransformSpaceWorld];
                [rotate_timer_left invalidate];
                [rotate_timer_right invalidate];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
        }
        default:
            break;
    }
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CCCVector3 scale = mModel.arObject.transform.scale;
            //                     地址       增量
            scale = CCCVector3Muls(&scale, pinch.scale);
            [mModel.arObject.transform setScale:scale];
            [rotate_timer_left invalidate];
            [rotate_timer_right invalidate];
            pinch.scale = 1.0f;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            //pinch.scale = 1.0f;
        }
        default:
            break;
    }
}

- (void)rotate:(UIRotationGestureRecognizer *)rotate {
    switch (rotate.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [mModel.arObject.transform rotateUpDegrees:- CCCRad2Deg(rotate.rotation)];
            rotate.rotation = 0.0f;
            [rotate_timer_left invalidate];
            [rotate_timer_right invalidate];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
        }
        default:
            break;
    }
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    [rotate_timer_left invalidate];
    [rotate_timer_right invalidate];
    switch (singleTap.view.tag) {
        case R_id_AR_left: {
            [mModel.arObject.transform rotateUpDegrees:22.5f];
            break;
        }
        case R_id_AR_right: {
            [mModel.arObject.transform rotateUpDegrees:-22.5f];
            break;
        }
        case R_id_btn_screenshot:{
            id<ICVGameEngine> engine = mModel.currentContext.engine;
            id<ICVRenderTimer> renderTimer = engine.renderTimer;
            CCVOnSnapshotListener* listener = [[CCVOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                NSLog(@"ARscreenshot");
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
            });
            CGRect frame = engine.frame.view.frameInPixels;
            CCCRect screenshotRect = CCCRectMake(0.0f, 0.0f, frame.size.width-(10*[UIScreen mainScreen].scale), frame.size.height-(10*[UIScreen mainScreen].scale));
            [renderTimer snapshotByRect:screenshotRect async:YES listener:listener];
            [CCVCoreUtils playCameraSound];
        }
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
//    [rotate_timer_left invalidate];
//    [rotate_timer_right invalidate];
        switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            switch (longPress.view.tag) {
                case R_id_AR_right: {
                    rotate_timer_right = [NSTimer scheduledTimerWithTimeInterval:0.0167f target:self selector:@selector(rotateRight) userInfo:nil repeats:YES];
                    break;
                }
                case R_id_AR_left: {
                    rotate_timer_left = [NSTimer scheduledTimerWithTimeInterval:0.0167f target:self selector:@selector(rotateLeft) userInfo:nil repeats:YES];
                    break;
                }
            }
        }
            case UIGestureRecognizerStateChanged:{
                break;
            }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            [rotate_timer_left invalidate];
            [rotate_timer_right invalidate];
            break;
        }
        default:
            break;
    }
}

- (void)rotateLeft {
    [mModel.arObject.transform rotateUpDegrees:1.0f];
}

- (void)rotateRight{
    [mModel.arObject.transform rotateUpDegrees:-1.0f];
}

@end
