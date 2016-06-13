//
//  Stretch.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/30.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Stretch.h"

@interface Stretch() {
    NSNumber* mPx;
    NSNumber* mPy;
    NSNumber* mPz;
    
    NSNumber* mOx;
    NSNumber* mOy;
    NSNumber* mOz;
}

@end

@implementation Stretch

@synthesize px = mPx;
@synthesize py = mPy;
@synthesize pz = mPz;

@synthesize ox = mOx;
@synthesize oy = mOy;
@synthesize oz = mOz;

- (NSDictionary *)serializeMembers {
    return @{
             @"px":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"py":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"pz":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"ox":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"oy":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"oz":[JWSerializeInfo objectWithClass:[NSNumber class]],
             };
}

@end
