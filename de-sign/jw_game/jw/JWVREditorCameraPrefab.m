//
//  JWVREditorCameraPrefab.m
//  June Winter_game
//
//  Created by ddeyes on 16/1/22.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWVREditorCameraPrefab.h"
#import "JWGameContext.h"
#import "JWVRCamera.h"

@implementation JWVREditorCameraPrefab

- (id<JICamera>)onCreateCameraWithContext:(id<JIGameContext>)context {
    return [context createVRCamera];
}

@end
