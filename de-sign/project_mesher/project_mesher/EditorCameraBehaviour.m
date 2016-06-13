//
//  EditorCameraBehaviour.m
//  project_mesher
//
//  Created by mac zdszkj on 16/3/21.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "EditorCameraBehaviour.h"
#import "MesherModel.h"

@interface EditorCameraBehaviour () {
    id<IMesherModel> mModel;
}

@end

@implementation EditorCameraBehaviour

@synthesize model = mModel;

- (id)initWithContext:(id<JIGameContext>)context cameraPrefab:(id<JICameraPrefab>)cameraPrefab model:(id<IMesherModel>)model {
    self = [super initWithContext:context cameraPrefab:cameraPrefab];
    if (self != nil) {
        mModel = model;
    }
    return self;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
//    [mCameraPrefab scaleS:-(pinch.scale - 1.0f)];
//    pinch.scale = 1.0f;
    [super onPinch:pinch];
    JCVector3 cameraPosition = [mCameraPrefab.camera.transform positionInSpace:JWTransformSpaceWorld];
    if (mModel.currentPlan.architureHeight != 0) {
        for (id<JIGameObject> obj in mModel.currentPlan.objects) {
            Item *item = [Data getItemFromInstance:obj];
            if (item.product.position == PositionTop) {
                if (mModel.currentPlan.architureHeight > cameraPosition.y) {
                    obj.visible = YES;
                }else {
                    obj.visible = NO;
                }
            }
        }
    }
    NSLog(@"%f,%f,%f",cameraPosition.x,cameraPosition.y,cameraPosition.z);
    mModel.currentPlan.sceneDirty = YES;
}

- (BOOL)onScreenTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    [super onScreenTouchMove:touches withEvent:event];
    JCVector3 cameraPosition = [mCameraPrefab.camera.transform positionInSpace:JWTransformSpaceWorld];
    if (mModel.currentPlan.architureHeight != 0) {
        for (id<JIGameObject> obj in mModel.currentPlan.objects) {
            Item *item = [Data getItemFromInstance:obj];
            if (item.product.position == PositionTop) {
                if (mModel.currentPlan.architureHeight > cameraPosition.y) {
                    obj.visible = YES;
                }else {
                    obj.visible = NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)onScreenTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    [super onScreenTouchUp:touches withEvent:event];
    mModel.currentPlan.sceneDirty = YES;
    return YES;
}

- (BOOL)onScreenTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    [super onScreenTouchCancel:touches withEvent:event];
    mModel.currentPlan.sceneDirty = YES;
    return YES;
}

@end
