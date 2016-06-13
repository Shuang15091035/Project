//
//  JWMultiCamera.h
//  June Winter_game
//
//  Created by ddeyes on 16/1/21.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWCamera.h>

@protocol JIMultiCamera <JICamera>

- (void) enumCameraUsing:(void (^)(id<JICamera> camera, NSUInteger idx))block;
- (BOOL) preRenderCamera:(id<JICamera>)camera atIndex:(NSUInteger)idx;
- (void) postRenderCamera:(id<JICamera>)camera atIndex:(NSUInteger)idx;

@end

@interface JWMultiCamera : JWCamera <JIMultiCamera>

@end
