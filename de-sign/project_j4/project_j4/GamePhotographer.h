//
//  GamePhotographer.h
//  project_mesher
//
//  Created by MacMini on 15/10/14.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface GamePhotographer : NSObject

- (id) initWithModel:(id<IMesherModel>)model scene:(id<ICVGameScene>)scene;
- (CCVBirdCameraPrefab*) changeToBirdCamera:(NSUInteger)duration;
//- (CCVFPSCameraPrefab*) changeToFPSCamera:(NSUInteger)duration;
- (CCVEditorCameraPrefab*) changeToEditorCamera:(NSUInteger)duration;
- (CCVDeviceCamera*) changeToFPSCamera:(NSUInteger)duration;
- (CCVVRDeviceCamera*) changeToVRCamera:(NSUInteger)duration;
@property (nonatomic, readwrite) BOOL cameraEnabled;

@property (nonatomic, readonly) CCVEditorCameraPrefab* archEditCamera;
- (CCVEditorCameraPrefab*)changeToArchEditCamera:(NSUInteger)duration;

@end
