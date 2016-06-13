//
//  Scale.m
//  project_mesher
//
//  Created by mac zdszkj on 16/6/3.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Scale.h"

@interface Scale() {
    NSNumber* mSx;
    NSNumber* mSy;
    NSNumber* mSz;
}

@end

@implementation Scale

@synthesize sx = mSx;
@synthesize sy = mSy;
@synthesize sz = mSz;

- (NSDictionary *)serializeMembers {
    return @{
             @"sx":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"sy":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"sz":[JWSerializeInfo objectWithClass:[NSNumber class]],
             };
}

@end
