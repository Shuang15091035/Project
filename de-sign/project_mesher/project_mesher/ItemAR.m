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
    JWRelativeLayout *lo_empty;
//    JWCameraView *cv_item_AR;
    JWRelativeLayout *lo_game_view;
    JWFrameLayout *lo_menu_right;
    UIView *gameView;
    CGRect rect_lo;
    CGRect rect;
    JWDeviceCamera *arCamera;
    
    UIButton *btn_left;
    UIButton *btn_right;
    NSTimer *rotate_timer_left;
    NSTimer *rotate_timer_right;
    
    JCVector3 oldPosition;
    JCVector3 newPosition;
    
    JCColor arRimColor;
    int arRimColorCount;
}

@end

@implementation ItemAR

- (UIView *)onCreateView:(UIView *)parent {
    
    //cv_item_AR = (JWCameraView*)[parent viewWithTag:R_id_camera_view];
    lo_empty = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_empty];
    lo_menu_right = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    
    UIImage *btn_close_white = [UIImage imageByResourceDrawable:@"btn_close_white"];
    UIButton *btn_close = [[UIButton alloc] initWithImage:btn_close_white selectedImage:btn_close_white];
    btn_close.layoutParams.width = JWLayoutWrapContent;
    btn_close.layoutParams.height = JWLayoutWrapContent;
    btn_close.layoutParams.alignment = JWLayoutAlignParentTopRight;
    btn_close.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
    btn_close.layoutParams.marginRight = [MesherModel uiWidthBy:20.0f];
    [lo_empty addSubview:btn_close];
    [btn_close addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btn_screenshot_p = [UIImage imageByResourceDrawable:@"btn_screenAR"];
    UIImageView *btn_screenshot = [[UIImageView alloc] initWithImage:btn_screenshot_p];
    btn_screenshot.tag = R_id_btn_screenshot;
    btn_screenshot.layoutParams.width = JWLayoutWrapContent;
    btn_screenshot.layoutParams.height = JWLayoutWrapContent;
    btn_screenshot.layoutParams.alignment = JWLayoutAlignParentRight | JWLayoutAlignCenterVertical;
    btn_screenshot.layoutParams.marginRight = [MesherModel uiWidthBy:80.0f];
    [lo_empty addSubview:btn_screenshot];
    
    lo_empty.clickable = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [lo_empty addGestureRecognizer:pan];
    
    [self.gestureEventBinder bindEventsWithType:JWGestureTypePinch toView:lo_empty willBindSubviews:NO andFilter:nil];
    
    UIRotationGestureRecognizer * rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [lo_empty addGestureRecognizer:rotate];
    
    //    [self.gestureEventBinder.lastPinchGestureRecognizerrotate requireGestureRecognizerToFail:rotate];
    
    lo_game_view = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    gameView = [parent viewWithTag:R_id_game_view];
    
    
    rect_lo = lo_game_view.frame;
    rect = gameView.frame;
    
    UIImage *bg_right = [UIImage imageByResourceDrawable:@"bg_right"];
    btn_right = [[UIButton alloc] init];
    btn_right.tag = R_id_AR_right;
    [btn_right setImage:bg_right forState:UIControlStateNormal];
    btn_right.alpha = 0.5f;
    btn_right.layoutParams.width = JWLayoutWrapContent;
    btn_right.layoutParams.height = JWLayoutWrapContent;
    btn_right.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    btn_right.layoutParams.marginRight = [MesherModel uiWidthBy:150.0f];
    btn_right.layoutParams.marginBottom = [MesherModel uiHeightBy:200.0f];
    [lo_empty addSubview:btn_right];
    
    UIImage *bg_left = [UIImage imageByResourceDrawable:@"bg_left"];
    btn_left = [[UIButton alloc] init];
    btn_left.tag = R_id_AR_left;
    [btn_left setImage:bg_left forState:UIControlStateNormal];
    btn_left.alpha = 0.5f;
    btn_left.layoutParams.width = JWLayoutWrapContent;
    btn_left.layoutParams.height = JWLayoutWrapContent;
    btn_left.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
    btn_left.layoutParams.marginLeft = [MesherModel uiWidthBy:150.0f];
    btn_left.layoutParams.marginBottom = [MesherModel uiHeightBy:200.0f];
    [lo_empty addSubview:btn_left];
    
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_right willBindSubviews:NO andFilter:nil];
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_left willBindSubviews:NO andFilter:nil];
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeLongPress toView:btn_right willBindSubviews:NO andFilter:nil];
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeLongPress toView:btn_left willBindSubviews:NO andFilter:nil];
    
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
    
//    UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
//    doubleTapGestureRecognizer.numberOfTouchesRequired = 1;
//    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
//    doubleTapGestureRecognizer.delegate = self;
//    [lo_empty addGestureRecognizer:doubleTapGestureRecognizer];
    
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
    mModel.arObject = [mModel.selectedObject copyInstanceUsingFilter:^BOOL(id<JIGameObject> object, id<JIComponent> component) {
        ItemInfo *info = [Data getItemInfoFromInstance:object];
        if (info.isOverlap) {
            [mModel.currentPlan hidedDecals:object];
        }
        if (object == mModel.itemRectFrameDecals.decalsObject) {
            return NO;
        }
        return YES;
    } withPrefix:nil];
    
//    arRimColorCount = 0;
//    arRimColor = JCColorNull();
//    [self enumChildrenUsing:mModel.arObject];
//    arRimColor.r /= arRimColorCount;
//    arRimColor.g /= arRimColorCount;
//    arRimColor.b /= arRimColorCount;
//    arRimColor.a /= arRimColorCount;
//    if (arRimColorCount == 0 || JCColorIsNull(&arRimColor)) {
//        arRimColor = JCColorMake(0.5, 0.5, 0.5, 1.0);
//    }
//    mModel.arVideoMaterial.outlineColor = arRimColor;
    
    if (arCamera == nil) {
        arCamera = [[JWDeviceCamera alloc] initWithContext:mModel.currentContext parent:mModel.arScene.root cameraId:@"ArCamera"];
    }
    [mModel.arScene changeCameraById:arCamera.camera.Id];
    [arCamera start];
    [mModel.world changeSceneById:mModel.arScene.Id]; // world跳转到arScene
    //mModel.arScene.clearColor = JCColorTransparent();
    mModel.arScene.clearColor = JCColorMake(0.1f, 0.1f, 0.1f, 0.1f); // TODO 先这样实现阴影的显示
    
    lo_empty.hidden = NO;
    
    //[cv_item_AR startCamera]; // 开启摄像头
    [mModel.currentContext.cameraCapturer start];//开启
    
    mModel.arObject.parent = mModel.arScene.root; // 改变物件根节点 放到不同的场景中
    //[mModel.arObject.transform reset:NO]; // YES是把所有子对象归零
    [mModel.arObject.transform setPosition:JCVector3Zero()];
    [mModel.arObject.transform resetOrientation:NO];
    [mModel.arObject.transform translate:JCVector3Make(0.0f, 0.0f, -2.0f)];
    [mModel.arObject.transform yawDegrees:180.0f];
    
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

- (void)enumChildrenUsing:(id<JIGameObject>)obj {
    [obj.transform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
        id<JIGameObject> childObj = child.host; //host表示transform的属于者
        if (childObj.renderable != nil) {
            if ([childObj.renderable conformsToProtocol:@protocol(JIMeshRenderer)]){
                id<JIMeshRenderer> meshRenderer = (id<JIMeshRenderer>)childObj.renderable;
                JCColor rimColor = meshRenderer.material.rimColor;
                float rimPower = meshRenderer.material.rimPower;
                if(!JCColorIsNull(&rimColor)) {
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
//    [cv_item_AR stopCamera]; // 关闭摄像头
    [mModel.currentContext.cameraCapturer stop];//关闭
    [arCamera stop];
    lo_game_view.backgroundColor = [UIColor whiteColor];
    mModel.backgroundSprite.visible = YES;
    lo_game_view.frame = rect_lo;
    gameView.frame = rect;
    gameView.layoutParams.marginTop = 10;
    gameView.layoutParams.marginLeft = 10;
    gameView.layoutParams.marginBottom = 10;
    gameView.layoutParams.marginRight = lo_menu_right.frame.size.width + 10;
    //id<IMesherModel> model = mModel;
    mModel.photographer.cameraEnabled = NO;
    [mModel.world changeSceneById:mModel.currentScene.Id];
    
    [JWCoreUtils destroyObject:mModel.arObject]; // 离开时先把object删除
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
            JCRayPlaneIntersectResult result = [mModel.arScene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];
            if (result.hit) {
                newPosition = result.point;
                [mModel.arObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
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
            JCVector3 scale = mModel.arObject.transform.scale;
            //                     地址       增量
            scale = JCVector3Muls(&scale, pinch.scale);
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
            [mModel.arObject.transform rotateUpDegrees:- JCRad2Deg(rotate.rotation)];
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
            id<JIGameEngine> engine = mModel.currentContext.engine;
            id<JIRenderTimer> renderTimer = engine.renderTimer;
            JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                NSLog(@"ARscreenshot");
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
            });
            CGRect frame = engine.frame.view.frameInPixels;
            JCRect screenshotRect = JCRectMake(0.0f, 0.0f, frame.size.width-(10*[UIScreen mainScreen].scale), frame.size.height-(10*[UIScreen mainScreen].scale));
            [renderTimer snapshotByRect:screenshotRect async:YES listener:listener];
            [JWCoreUtils playCameraSound];
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

#pragma mark 双击截屏的逻辑 暂时不用 废弃
#if 0
- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap {
    id<JIGameEngine> engine = mModel.currentContext.engine;
    id<JIRenderTimer> renderTimer = engine.renderTimer;
    JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
    listener.onSnapshot = (^(UIImage* screenshot) {
        NSLog(@"ARscreenshot");
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    });
    CGRect frame = engine.frame.view.frameInPixels;
    JCRect screenshotRect = JCRectMake(0.0f, 0.0f, frame.size.width-(10*[UIScreen mainScreen].scale), frame.size.height-(10*[UIScreen mainScreen].scale));
    [renderTimer snapshotByRect:screenshotRect async:YES listener:listener];
    [JWCoreUtils playCameraSound];
}
#endif

- (void)rotateLeft {
    [mModel.arObject.transform rotateUpDegrees:1.0f];
}

- (void)rotateRight{
    [mModel.arObject.transform rotateUpDegrees:-1.0f];
}

@end
