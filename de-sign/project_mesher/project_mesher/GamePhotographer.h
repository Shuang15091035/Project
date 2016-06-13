//
//  GamePhotographer.h
//  project_mesher
//
//  Created by MacMini on 15/10/14.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "EditorCamera.h"

@interface GamePhotographer : NSObject

- (id) initWithModel:(id<IMesherModel>)model scene:(id<JIGameScene>)scene;
- (JWBirdCameraPrefab*) changeToBirdCamera:(NSUInteger)duration;
- (JWFPSCameraPrefab*) changeToMFPSCamera:(NSUInteger)duration;
- (EditorCamera*) changeToEditorCamera:(NSUInteger)duration;
- (JWDeviceCamera*) changeToFPSCamera:(NSUInteger)duration;
- (JWVRDeviceCamera*) changeToVRCamera:(NSUInteger)duration;
@property (nonatomic, readwrite) BOOL cameraEnabled;

@property (nonatomic, readonly) JWEditorCameraPrefab* archEditCamera;
- (JWEditorCameraPrefab*)changeToArchEditCamera:(NSUInteger)duration;

@end
