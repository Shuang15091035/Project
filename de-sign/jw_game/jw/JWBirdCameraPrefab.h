//
//  JWBirdCameraPrefab.h
//  June Winter_game
//
//  Created by ddeyes on 15/10/26.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWCameraPrefab.h>

@interface JWBirdCameraPrefab : JWCameraPrefab

- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString*)cameraId initZoom:(float)initZoom;

@end
