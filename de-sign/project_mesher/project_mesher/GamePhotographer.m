//
//  GamePhotographer.m
//  project_mesher
//
//  Created by MacMini on 15/10/14.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "GamePhotographer.h"
#import <jw/JWEditorCameraPrefab.h>
#import "MesherModel.h"
#import "EditorCameraBehaviour.h"

@interface GamePhotographer (){
    id<IMesherModel> mModel;
    id<JIGameScene> mScene;
    id<JIGameObject> mRoot;
    JWBirdCameraPrefab* mBirdCamera;
    EditorCamera* mEditorCamera;
    JWFPSCameraPrefab* mMFpsCamera;
    JWCameraPrefab* mCurrentCamera;
    JWDeviceCamera* mFPSCamera;
    JWVRDeviceCamera* mVRCamera;
    
    JWEditorCameraPrefab* mArchEditCamera;
    
    id<JIGameObject> fpsObject;
}
@end

@implementation GamePhotographer

- (id)initWithModel:(id<IMesherModel>)model scene:(id<JIGameScene>)scene {
    self = [super init];
    if(self != nil){
        mModel = model;
        mScene = scene;
        
        id<JIGameContext> context = scene.context;
        mRoot = [context createObject];
        mRoot.Id = @"photographer";
        mRoot.parent = scene.root;
        mRoot.queryMask = SelectedMaskCannotSelect;
        
        mBirdCamera = [[JWBirdCameraPrefab alloc] initWithContext:context parent:mRoot cameraId:@"brid camera" initZoom:15.0f];
        [mBirdCamera.camera setProjectionMode:JWProjectionModeOrtho];
        mBirdCamera.camera.orthoScale = 0.01f;
        mBirdCamera.move1Speed = 0.01f;
        mBirdCamera.scaleSpeed = 5.0f;
//        mBirdCamera.root.queryMask = SelectedMaskCannotSelect;
        [mBirdCamera.root setQueryMask:SelectedMaskCannotSelect recursive:YES];
        
        mEditorCamera = [[EditorCamera alloc] initWithContext:context parent:mRoot cameraId:@"editor camera" initPicth:0.0f initYaw:0.0f initZoom:0.0f];
        mEditorCamera.camera.zNear = 0.1f;
        mEditorCamera.camera.zFar = 100.0f;
        mEditorCamera.move1Speed = 0.2f;
        mEditorCamera.scaleSpeed = 1.5f;
        mEditorCamera.move2Enabled = YES; // 双指操作设置
        mEditorCamera.move2Speed = 0.01f;
        mEditorCamera.pitchConstraintEnabled = YES;
        mEditorCamera.minPitch = -90.0f;
        mEditorCamera.maxPitch = -10.0f;
//        mEditorCamera.root.queryMask = SelectedMaskCannotSelect;
        [mEditorCamera.root setQueryMask:SelectedMaskCannotSelect recursive:YES];
        [mEditorCamera.camera.host removeComponent:mEditorCamera.camera.host.behaviour];
        EditorCameraBehaviour *behaviour = [[EditorCameraBehaviour alloc] initWithContext:mModel.currentContext cameraPrefab:mEditorCamera];
        behaviour.model = mModel;
        [mEditorCamera.camera.host addComponent:behaviour];
        
        mMFpsCamera = [[JWFPSCameraPrefab alloc] initWithContext:context parent:mRoot cameraId:@"mfps camera" initPicth:0.0f initYaw:90.0f initHeight:1.6f];
        mMFpsCamera.move1Speed = 0.1f;
        mMFpsCamera.scaleSpeed = 1.5f;
        mMFpsCamera.root.queryMask = SelectedMaskCannotSelect;
        
        
        fpsObject = [context createObject];
        fpsObject.parent = mRoot;
        mFPSCamera = [[JWDeviceCamera alloc] initWithContext:context parent:fpsObject cameraId:@"fps camera"];
        mFPSCamera.move1Speed = 0.1f;
        mFPSCamera.scaleSpeed = 1.5f;
        mFPSCamera.root.queryMask = SelectedMaskCannotSelect;
//        fpsObject = [context createObject];
//        fpsObject.parent = mFPSCamera.camera.host.parent;
//        mFPSCamera.camera.host.parent = fpsObject;
        
        mVRCamera = [[JWVRDeviceCamera alloc] initWithContext:context parent:mRoot cameraId:@"vr camera"];
        mVRCamera.move1Speed = 0.1f;
        mVRCamera.scaleSpeed = 1.5f;
//        mVRCamera.root.queryMask = SelectedMaskCannotSelect;
        [mVRCamera.root setQueryMask:SelectedMaskCannotSelect recursive:YES];
        
        mArchEditCamera = [[JWEditorCameraPrefab alloc] initWithContext:context parent:scene.root cameraId:@"arch camera" initPicth:-10.0f initYaw:15.0f initZoom:0.5f];
        mArchEditCamera.camera.zNear = 0.1f;
        mArchEditCamera.camera.zFar = 100.0f;
        mArchEditCamera.move1Speed = 0.2f;
        mArchEditCamera.scaleSpeed = 1.5f;
//        mArchEditCamera.move2Enabled = YES;
//        mArchEditCamera.move2Speed = 0.01f;
        mArchEditCamera.pitchConstraintEnabled = NO;// 角度限制
        mArchEditCamera.minPitch = -90.0f;
        mArchEditCamera.maxPitch = -10.0f;
//        mArchEditCamera.root.queryMask = SelectedMaskCannotSelect;
        [mArchEditCamera.root setQueryMask:SelectedMaskCannotSelect recursive:YES];
        
        [self changeToEditorCamera:0];
    }
    return self;
}

- (JWBirdCameraPrefab *)changeToBirdCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil && mCurrentCamera != mArchEditCamera) {
        JCVector3 position = mCurrentCamera.root.transform.position;
        [mBirdCamera.root.transform setPosition:position];
    }
    [mScene changeCameraById:mBirdCamera.camera.Id duration:0];
    [mVRCamera stop];
    [mFPSCamera stop];
    mCurrentCamera = mBirdCamera;
    [self adjustTop];
    mModel.currentCamera = mCurrentCamera;
    return mBirdCamera;
}

- (JWFPSCameraPrefab *)changeToMFPSCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil && mCurrentCamera != mArchEditCamera) {
        JCVector3 position = mCurrentCamera.root.transform.position;
        [mMFpsCamera.root.transform setPosition:position];
    }
    if (mCurrentCamera == mFPSCamera) {
        JCVector3 camera_fps = [mFPSCamera.camera.transform zAxisInSpace:JWTransformSpaceWorld];
        camera_fps.y = 0.0f;
        camera_fps = JCVector3Normalize(&camera_fps);
        JCVector3 camera_mfps = [mMFpsCamera.camera.transform zAxisInSpace:JWTransformSpaceWorld];
        camera_mfps.y = 0.0f;
        camera_mfps = JCVector3Normalize(&camera_mfps);
        float d = JCVector3DotProductv(&camera_fps, &camera_mfps);
        if (d > 1.0f) {
            d = 1.0f;
        }else if (d < -1.0f) {
            d = -1.0f;
        }
        float radians = acosf(d);
        float degrees = JCRad2Deg(radians);
        JCVector3 cn = JCVector3CrossProductv(&camera_mfps, &camera_fps);
        if (cn.y < 0.0f) {
            degrees = -degrees;
        }
        [mMFpsCamera.root.transform yawDegrees:degrees];
    }
    
    
    [mScene changeCameraById:mMFpsCamera.camera.Id duration:duration];
    [mVRCamera stop];
    [mFPSCamera stop];
    mCurrentCamera = mMFpsCamera;
    [self showTop];
    mModel.currentCamera = mCurrentCamera;
    return mMFpsCamera;
}

- (JWEditorCameraPrefab *)changeToEditorCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil && mCurrentCamera != mArchEditCamera) {
        JCVector3 position = mCurrentCamera.root.transform.position;
        [mEditorCamera.root.transform setPosition:position];
    }
    [mScene changeCameraById:mEditorCamera.camera.Id duration:duration];
    [mVRCamera stop];
    [mFPSCamera stop];
    mCurrentCamera = mEditorCamera;
    [self adjustTop];
    mModel.currentCamera = mCurrentCamera;
    return mEditorCamera;
}

- (JWDeviceCamera *)changeToFPSCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil && mCurrentCamera != mArchEditCamera) {
        JCVector3 position = mCurrentCamera.root.transform.position;
//        JCVector3 position = mModel.cameraPosition;
        [mFPSCamera.root.transform setPosition:position];
    }
    if (mCurrentCamera == mMFpsCamera) {
        JCVector3 camera_mfps = [mMFpsCamera.camera.transform zAxisInSpace:JWTransformSpaceWorld];
        camera_mfps.y = 0.0f;
        camera_mfps = JCVector3Normalize(&camera_mfps);
        JCVector3 camera_fps = [mFPSCamera.camera.transform zAxisInSpace:JWTransformSpaceWorld];
        camera_fps.y = 0.0f;
        camera_fps = JCVector3Normalize(&camera_fps);
        float d = JCVector3DotProductv(&camera_mfps, &camera_fps);
        if (d > 1.0f) {
            d = 1.0f;
        }else if (d < -1.0f) {
            d = -1.0f;
        }
        float radians = acosf(d);
        float degrees = JCRad2Deg(radians);
        JCVector3 cn = JCVector3CrossProductv(&camera_fps, &camera_mfps);
        if (cn.y < 0.0f) {
            degrees = -degrees; 
        }
        [fpsObject.transform yawDegrees:degrees];
    }
    
    [mScene changeCameraById:mFPSCamera.camera.Id duration:duration];
    [mVRCamera stop];
    [mFPSCamera start];
    mCurrentCamera = mFPSCamera;
    [self showTop];
    mModel.currentCamera = mCurrentCamera;
    return mFPSCamera;
}

- (JWVRDeviceCamera *)changeToVRCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil && mCurrentCamera != mArchEditCamera) {
        JCVector3 position = mCurrentCamera.root.transform.position;
        [mVRCamera.root.transform setPosition:position];
    }
    [mScene changeCameraById:mVRCamera.camera.Id duration:duration];
    [mFPSCamera stop];
    [mVRCamera start];
    mCurrentCamera = mVRCamera;
    mModel.currentCamera = mCurrentCamera;
    return mVRCamera;
}

- (JWEditorCameraPrefab *)archEditCamera {
    return mArchEditCamera;
}

- (JWEditorCameraPrefab *)changeToArchEditCamera:(NSUInteger)duration {
//    if (mCurrentCamera != nil) {
//        [mArchEditCamera.root.transform setPositionV:position];
//    }
    [mScene changeCameraById:mArchEditCamera.camera.Id duration:duration];
    [mVRCamera stop];
    [mFPSCamera stop];
    mCurrentCamera = mArchEditCamera;
    mModel.currentCamera = mCurrentCamera;
    return mArchEditCamera;
}

- (BOOL)cameraEnabled {
    // TODO 现在用不到
    return NO;
}

- (void)setCameraEnabled:(BOOL)cameraEnabled {
    mBirdCamera.camera.host.enabled = cameraEnabled;
    mMFpsCamera.camera.host.enabled = cameraEnabled;
    mEditorCamera.camera.host.enabled = cameraEnabled;
    mFPSCamera.camera.host.enabled = cameraEnabled;
    mVRCamera.camera.host.enabled = cameraEnabled;
    mArchEditCamera.camera.host.enabled = cameraEnabled;
}

- (void)showTop {
    for (id<JIGameObject> obj in mModel.currentPlan.objects) {
        Item *item = [Data getItemFromInstance:obj];
        if (item.product.position == PositionTop) {
            obj.visible = YES;
        }
    }
}

- (void)adjustTop {
    JCVector3 cameraPosition = [mCurrentCamera.camera.transform positionInSpace:JWTransformSpaceWorld];
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
}

@end


