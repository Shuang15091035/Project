//
//  JWDeviceCamera.h
//  June Winter_game
//
//  Created by ddeyes on 15/11/19.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWCameraPrefab.h>

@interface JWDeviceCamera : JWCameraPrefab

- (void) start;
- (void) stop;

@property (nonatomic, readwrite) float height;

@end
