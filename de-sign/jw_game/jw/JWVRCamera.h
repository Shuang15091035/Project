//
//  JWVRCamera.h
//  June Winter_game
//
//  Created by ddeyes on 16/1/21.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWMultiCamera.h>

@protocol JIVRCamera <JIMultiCamera>

@property (nonatomic, readonly) id<JICamera> leftEye;
@property (nonatomic, readonly) id<JICamera> rightEye;
@property (nonatomic, readwrite) float IPD; // 瞳距

@end

@interface JWVRCamera : JWMultiCamera <JIVRCamera>

@end
