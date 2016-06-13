//
//  JWCameraView.h
//  jw_app
//
//  Created by ddeyes on 15/11/18.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface JWCameraView : UIView

+ (id) cameraView;
- (BOOL) startCamera;
- (BOOL) stopCamera;
- (BOOL) toggleCamera;

@end
