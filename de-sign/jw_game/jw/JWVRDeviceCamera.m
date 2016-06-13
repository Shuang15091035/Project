//
//  JWVRDeviceCamera.m
//  June Winter_game
//
//  Created by ddeyes on 16/1/26.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWVRDeviceCamera.h"
#import "JWGameContext.h"
#import "JWVRCamera.h"

@implementation JWVRDeviceCamera

- (id<JICamera>)onCreateCameraWithContext:(id<JIGameContext>)context {
    return [context createVRCamera];
}

@end
