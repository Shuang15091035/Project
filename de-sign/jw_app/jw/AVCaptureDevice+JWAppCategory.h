//
//  AVCaptureDevice+JWAppCategory.h
//  jw_app
//
//  Created by ddeyes on 15/12/12.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVCaptureDevice (JWAppCategory)

+ (AVCaptureDevice*) backCamera;
+ (AVCaptureDevice*) frontCamera;
+ (AVCaptureDevice*) cameraWithPosition:(AVCaptureDevicePosition)position;

@end
