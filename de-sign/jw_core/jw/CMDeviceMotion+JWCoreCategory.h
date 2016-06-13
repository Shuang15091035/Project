//
//  CMDeviceMotion+JWCoreCategory.h
//  jw_core
//
//  Created by GavinLo on 15/3/24.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
#import <jw/JCQuaternion.h>

@interface CMDeviceMotion (JWCoreCategory)

//- (JCQuaternion) orientationByDeviceOrientation:(UIDeviceOrientation)orientation;
- (JCQuaternion) orientationByInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (CMAcceleration) userAccelerationInReferenceFrame;
- (CMAcceleration) gravityInReferenceFrame;

@property (nonatomic, readonly) CMAcceleration userAccelerationInGlobalFrame;

@end
