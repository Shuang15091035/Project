//
//  GamePhotographer.m
//  project_mesher
//
//  Created by MacMini on 15/10/14.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "GamePhotographer.h"
#import <ctrlcv/CCVEditorCameraPrefab.h>
#import "MesherModel.h"

@interface GamePhotographer (){
    id<IMesherModel> mModel;
    id<ICVGameScene> mScene;
    id<ICVGameObject> mRoot;
    CCVBirdCameraPrefab* mBirdCamera;
    CCVEditorCameraPrefab* mEditorCamera;
//    CCVFPSCameraPrefab* mFpsCamera;
    CCVCameraPrefab* mCurrentCamera;
    CCVDeviceCamera* mFPSCamera;
    CCVVRDeviceCamera* mVRCamera;
    
    CCVEditorCameraPrefab* mArchEditCamera;
}
@end

@implementation GamePhotographer

- (id)initWithModel:(id<IMesherModel>)model scene:(id<ICVGameScene>)scene {
    self = [super init];
    if(self != nil){
        mModel = model;
        mScene = scene;
        
        id<ICVGameContext> context = scene.context;
        mRoot = [context createObject];
        mRoot.Id = @"photographer";
        mRoot.parent = scene.root;
        
        mBirdCamera = [[CCVBirdCameraPrefab alloc] initWithContext:context parent:mRoot cameraId:@"brid camera" initZoom:15.0f];
        [mBirdCamera.camera setProjectionMode:CCVProjectionModeOrtho];
        mBirdCamera.camera.orthoScale = 0.01f;
        mBirdCamera.move1Speed = 0.01f;
        mBirdCamera.scaleSpeed = 5.0f;
        mBirdCamera.root.queryMask = [MesherModel CanNotSelectMask];
        
        mEditorCamera = [[CCVEditorCameraPrefab alloc] initWithContext:context parent:mRoot cameraId:@"editor camera" initPicth:-10.0f initYaw:15.0f initZoom:10.0f];
        mEditorCamera.camera.zNear = 0.1f;
        mEditorCamera.camera.zFar = 100.0f;
        mEditorCamera.move1Speed = 0.2f;
        mEditorCamera.scaleSpeed = 1.5f;
        mEditorCamera.move2Enabled = YES; // 双指操作设置
        mEditorCamera.move2Speed = 0.01f;
        mEditorCamera.pitchConstraintEnabled = YES;
        mEditorCamera.minPitch = -90.0f;
        mEditorCamera.maxPitch = -10.0f;
        mEditorCamera.root.queryMask = [MesherModel CanNotSelectMask];
        
//        mFpsCamera = [[CCVFPSCameraPrefab alloc] initWithContext:context parent:mRoot cameraId:@"fps camera" initPicth:0.0f initYaw:90.0f initHeight:1.6f];
//        mFpsCamera.move1Speed = 0.1f;
//        mFpsCamera.scaleSpeed = 1.5f;
//        mFpsCamera.root.queryMask = [MesherModel CanNotSelectMask];
        
        mFPSCamera = [[CCVDeviceCamera alloc] initWithContext:context parent:mRoot cameraId:@"fps camera"];
        mFPSCamera.move1Speed = 0.1f;
        mFPSCamera.scaleSpeed = 1.5f;
        mFPSCamera.root.queryMask = [MesherModel CanNotSelectMask];
        
        mVRCamera = [[CCVVRDeviceCamera alloc] initWithContext:context parent:mRoot cameraId:@"vr camera"];
        mVRCamera.move1Speed = 0.1f;
        mVRCamera.scaleSpeed = 1.5f;
        mVRCamera.root.queryMask = [MesherModel CanNotSelectMask];
        
        mArchEditCamera = [[CCVEditorCameraPrefab alloc] initWithContext:context parent:scene.root cameraId:@"arch camera" initPicth:-10.0f initYaw:15.0f initZoom:0.5f];
        mArchEditCamera.camera.zNear = 0.1f;
        mArchEditCamera.camera.zFar = 100.0f;
        mArchEditCamera.move1Speed = 0.2f;
        mArchEditCamera.scaleSpeed = 1.5f;
//        mArchEditCamera.move2Enabled = YES;
//        mArchEditCamera.move2Speed = 0.01f;
        mArchEditCamera.pitchConstraintEnabled = NO;// 角度限制
        mArchEditCamera.minPitch = -90.0f;
        mArchEditCamera.maxPitch = -10.0f;
        mArchEditCamera.root.queryMask = [MesherModel CanNotSelectMask];
        
        [self changeToEditorCamera:0];
    }
    return self;
}

- (CCVBirdCameraPrefab *)changeToBirdCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil) {
        CCCVector3 position = mCurrentCamera.root.transform.position;
        [mBirdCamera.root.transform setPositionV:position];
    }
    [mScene changeCameraById:mBirdCamera.camera.Id duration:0];
    [mVRCamera stop];
    [mFPSCamera stop];
    mCurrentCamera = mBirdCamera;
    return mBirdCamera;
}

//- (CCVFPSCameraPrefab *)changeToFPSCamera:(NSUInteger)duration {
//    if (mCurrentCamera != nil) {
//        CCCVector3 position = mCurrentCamera.root.transform.position;
//        [mFpsCamera.root.transform setPositionV:position];
//    }
//    [mScene changeCameraById:mFpsCamera.camera.Id duration:duration];
//    [mVRCamera stop];
//    mCurrentCamera = mFpsCamera;
//    return mFpsCamera;
//}

- (CCVEditorCameraPrefab *)changeToEditorCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil) {
        CCCVector3 position = mCurrentCamera.root.transform.position;
        [mEditorCamera.root.transform setPositionV:position];
    }
    [mScene changeCameraById:mEditorCamera.camera.Id duration:duration];
    [mVRCamera stop];
    [mFPSCamera stop];
    mCurrentCamera = mEditorCamera;
    return mEditorCamera;
}

- (CCVDeviceCamera *)changeToFPSCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil) {
        CCCVector3 position = mCurrentCamera.root.transform.position;
//        CCCVector3 position = mModel.cameraPosition;
        [mFPSCamera.root.transform setPositionV:position];
    }
    [mScene changeCameraById:mFPSCamera.camera.Id duration:duration];
    [mVRCamera stop];
    [mFPSCamera start];
    mCurrentCamera = mFPSCamera;
    return mFPSCamera;
}

- (CCVVRDeviceCamera *)changeToVRCamera:(NSUInteger)duration {
    if (mCurrentCamera != nil) {
        CCCVector3 position = mCurrentCamera.root.transform.position;
        [mVRCamera.root.transform setPositionV:position];
    }
    [mScene changeCameraById:mVRCamera.camera.Id duration:duration];
    [mFPSCamera stop];
    [mVRCamera start];
    mCurrentCamera = mVRCamera;
    return mVRCamera;
}

- (CCVEditorCameraPrefab *)archEditCamera {
    return mArchEditCamera;
}

- (CCVEditorCameraPrefab *)changeToArchEditCamera:(NSUInteger)duration {
//    if (mCurrentCamera != nil) {
//        [mArchEditCamera.root.transform setPositionV:position];
//    }
    [mScene changeCameraById:mArchEditCamera.camera.Id duration:duration];
    [mVRCamera stop];
    [mFPSCamera stop];
    mCurrentCamera = mArchEditCamera;
    return mArchEditCamera;
}

- (BOOL)cameraEnabled {
    // TODO 现在用不到
    return NO;
}

- (void)setCameraEnabled:(BOOL)cameraEnabled {
    mBirdCamera.camera.host.enabled = cameraEnabled;
    //mFpsCamera.camera.host.enabled = cameraEnabled;
    mEditorCamera.camera.host.enabled = cameraEnabled;
    mFPSCamera.camera.host.enabled = cameraEnabled;
    mVRCamera.camera.host.enabled = cameraEnabled;
    mArchEditCamera.camera.host.enabled = cameraEnabled;
}

@end


