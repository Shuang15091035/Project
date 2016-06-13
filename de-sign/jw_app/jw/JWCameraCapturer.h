//
//  JWCameraCapturer.h
//  jw_app
//
//  Created by ddeyes on 16/2/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <jw/JWObject.h>

@protocol JICameraCapturer;
@protocol JICameraSampleHandler <NSObject>

- (void) cameraCapturer:(id<JICameraCapturer>)cameraCapturer didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

@protocol JICameraCapturer <JIObject>

- (BOOL) start;
- (BOOL) stop;
- (BOOL) toggle;
@property (nonatomic, readwrite) BOOL enabled;

- (void) registerSampleHandler:(id<JICameraSampleHandler>)sampleHandler;
- (void) unregisterSampleHandler:(id<JICameraSampleHandler>)sampleHandler;

@end

@interface JWCameraCapturer : JWObject <JICameraCapturer>

+ (id) capturer;

@end
