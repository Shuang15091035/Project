//
//  PlanCamera.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/19.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "PlanCamera.h"

@interface PlanCamera() {
    float mPx;
    float mPy;
    float mPz;
    
    float mRx;
    float mRy;
    float mRz;
    float mRw;
}

@end

@implementation PlanCamera

@synthesize px = mPx;
@synthesize py = mPy;
@synthesize pz = mPz;
@synthesize rx = mRx;
@synthesize ry = mRy;
@synthesize rz = mRz;
@synthesize rw = mRw;

- (NSDictionary *)serializeMembers {
    return @{
             @"px":[JWSerializeInfo objectWithName:@"px" objClass:[NSNumber class]],
             @"py":[JWSerializeInfo objectWithName:@"py" objClass:[NSNumber class]],
             @"pz":[JWSerializeInfo objectWithName:@"pz" objClass:[NSNumber class]],
             @"rx":[JWSerializeInfo objectWithName:@"rx" objClass:[NSNumber class]],
             @"ry":[JWSerializeInfo objectWithName:@"ry" objClass:[NSNumber class]],
             @"rz":[JWSerializeInfo objectWithName:@"rz" objClass:[NSNumber class]],
             @"rw":[JWSerializeInfo objectWithName:@"rw" objClass:[NSNumber class]],
             };
}

@end
