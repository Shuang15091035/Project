//
//  JWFPSCameraPrefab.h
//  June Winter
//
//  Created by GavinLo on 14/12/27.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWCameraPrefab.h>

@interface JWFPSCameraPrefab : JWCameraPrefab

- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString*)cameraId initPicth:(float)initPicth initYaw:(float)initYaw initHeight:(float)initHeight;

@end
