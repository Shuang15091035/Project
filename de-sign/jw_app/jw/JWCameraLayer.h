//
//  JWCameraLayer.h
//  jw_app
//
//  Created by ddeyes on 15/12/4.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface JWCameraLayer : AVCaptureVideoPreviewLayer

- (BOOL) startCamera;
- (BOOL) stopCamera;
- (BOOL) toggleCamera;

@end
