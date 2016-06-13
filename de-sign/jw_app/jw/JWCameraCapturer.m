//
//  JWCameraCapturer.m
//  jw_app
//
//  Created by ddeyes on 16/2/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCameraCapturer.h"
#import <jw/NSMutableArray+JWMutableArray.h>

@interface JWCameraCapturer () <AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession* mSession;
    NSMutableArray<id<JICameraSampleHandler>>* mSampleHandlers;
}

@property (nonatomic, readonly) AVCaptureDevice* backCamera;
@property (nonatomic, readonly) AVCaptureDevice* frontCamera;

@end

@implementation JWCameraCapturer

+ (id)capturer {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self setupCapturer];
    }
    return self;
}

- (void)dealloc {
    [self stop];
    mSession = nil;
    [mSampleHandlers removeAllObjects];
    mSampleHandlers = nil;
}

- (void) setupCapturer {
    AVCaptureDevice* device = self.backCamera; // 默认为后置摄像头
    NSError* error = nil;
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error != nil) {
        NSLog(@"%@", error.description);
        return;
    }
    mSession = [[AVCaptureSession alloc] init];
    [mSession beginConfiguration];
    mSession.sessionPreset = AVCaptureSessionPresetHigh; // 默认为高精度视频
    [mSession addInput:input];
    AVCaptureVideoDataOutput * dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    // 使用YUV输出
    // TODO 更多输出方式
    [dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    // 主线程调用delegate，可以直接设置opengl，有点厉害
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [mSession addOutput:dataOutput];
    [mSession commitConfiguration];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice*) cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice* device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (BOOL)start {
    if (mSession == nil) {
        return NO;
    }
    [mSession startRunning];
    return YES;
}

- (BOOL)stop {
    if (mSession == nil) {
        return NO;
    }
    [mSession stopRunning];
    return YES;
}

- (BOOL)toggle {
    if (mSession == nil) {
        return NO;
    }
    if (!mSession.isRunning) {
        [mSession startRunning];
    } else {
        [mSession stopRunning];
    }
    return YES;
}

- (BOOL)enabled {
    if (mSession == nil) {
        return NO;
    }
    return mSession.isRunning;
}

- (void)setEnabled:(BOOL)enabled {
    if (enabled) {
        [self start];
    } else {
        [self stop];
    }
}

- (void)registerSampleHandler:(id<JICameraSampleHandler>)sampleHandler {
    if (mSampleHandlers == nil) {
        mSampleHandlers = [NSMutableArray array];
    }
    [mSampleHandlers addObject:sampleHandler likeASet:YES willIngoreNil:YES];
}

- (void)unregisterSampleHandler:(id<JICameraSampleHandler>)sampleHandler {
    if (mSampleHandlers == nil) {
        return;
    }
    [mSampleHandlers removeObject:sampleHandler];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (mSampleHandlers != nil) {
        for (id<JICameraSampleHandler> sampleHandler in mSampleHandlers) {
            [sampleHandler cameraCapturer:self didOutputSampleBuffer:sampleBuffer];
        }
    }
}

@end
