//
//  JWCameraLayer.m
//  jw_app
//
//  Created by ddeyes on 15/12/4.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCameraLayer.h"
#import <AVFoundation/AVFoundation.h>

@interface JWCameraLayer ()

@property (nonatomic, readonly) AVCaptureDevice* backCamera;
@property (nonatomic, readonly) AVCaptureDevice* frontCamera;

@end

@implementation JWCameraLayer

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self initCamera];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self initCamera];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) initCamera {
    AVCaptureDevice* device = self.backCamera; // 默认为后置摄像头
    NSError* error = nil;
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error != nil) {
        NSLog(@"%@", error.description);
        return;
    }
    AVCaptureSession* session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh; // 默认为高精度视频
    [session addInput:input];
    self.session = session;
    self.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.masksToBounds = YES;
    
    [self orientationChanged:nil]; // 默认先处理一下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void) orientationChanged:(NSNotification*)notification {
    if (self.connection.supportsVideoOrientation) {
        switch ([[UIDevice currentDevice] orientation]) {
            case UIInterfaceOrientationLandscapeLeft: {
                self.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            }
            case UIInterfaceOrientationLandscapeRight: {
                self.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            }
            case UIInterfaceOrientationPortrait: {
                self.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
            }
            case UIInterfaceOrientationPortraitUpsideDown: {
                self.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            }
            default:
                break;
        }
    }
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

- (BOOL)startCamera {
    if (self.session == nil) {
        return NO;
    }
    [self.session startRunning];
    return YES;
}

- (BOOL)stopCamera {
    if (self.session == nil) {
        return NO;
    }
    [self.session stopRunning];
    return YES;
}

- (BOOL)toggleCamera {
    if (self.session == nil) {
        return NO;
    }
    if (!self.session.isRunning) {
        [self.session startRunning];
    } else {
        [self.session stopRunning];
    }
    return YES;
}

@end
