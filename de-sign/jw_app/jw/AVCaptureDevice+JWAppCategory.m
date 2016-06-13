//
//  AVCaptureDevice+JWAppCategory.m
//  jw_app
//
//  Created by ddeyes on 15/12/12.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "AVCaptureDevice+JWAppCategory.h"

@implementation AVCaptureDevice (JWAppCategory)

+ (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

+ (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

+ (AVCaptureDevice*) cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice* device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

@end
