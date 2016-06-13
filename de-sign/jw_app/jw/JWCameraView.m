//
//  JWCameraView.m
//  jw_app
//
//  Created by ddeyes on 15/11/18.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCameraView.h"

@interface JWCameraView () {
    AVCaptureSession* mSession;
    AVCaptureVideoPreviewLayer* mVideoLayer;
}

@property (nonatomic, readonly) AVCaptureDevice* backCamera;
@property (nonatomic, readonly) AVCaptureDevice* frontCamera;

@end

@implementation JWCameraView

+ (id)cameraView {
    return [[self alloc] init];
}

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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initCamera];
        mVideoLayer.frame = frame;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    mSession = nil;
    mVideoLayer = nil;
}

// 使用sublayer方式显示
//- (CALayer *)layer {
//    return mVideoLayer;
//}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    mVideoLayer.frame = frame;
}

- (void) initCamera {
    AVCaptureDevice* device = self.backCamera; // 默认为后置摄像头
    NSError* error = nil;
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error != nil) {
        NSLog(@"%@", error.description);
        return;
    }
    mSession = [[AVCaptureSession alloc] init];
    mSession.sessionPreset = AVCaptureSessionPresetHigh; // 默认为高精度视频
    [mSession addInput:input];
    mVideoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:mSession];
    mVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:mVideoLayer];
    
    [self orientationChanged:nil]; // 默认先处理一下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void) orientationChanged:(NSNotification*)notification {
    if (mVideoLayer.connection.supportsVideoOrientation) {
        switch ([[UIDevice currentDevice] orientation]) {
            case UIInterfaceOrientationLandscapeLeft: {
                mVideoLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            }
            case UIInterfaceOrientationLandscapeRight: {
                mVideoLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            }
            case UIInterfaceOrientationPortrait: {
                mVideoLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
            }
            case UIInterfaceOrientationPortraitUpsideDown: {
                mVideoLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
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
    if (mSession == nil) {
        return NO;
    }
    [mSession startRunning];
    return YES;
}

- (BOOL)stopCamera {
    if (mSession == nil) {
        return NO;
    }
    [mSession stopRunning];
    return YES;
}

- (BOOL)toggleCamera {
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

@end
