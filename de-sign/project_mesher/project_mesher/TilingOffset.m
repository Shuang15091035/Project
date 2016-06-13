//
//  TilingOffset.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/30.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TilingOffset.h"

@interface TilingOffset() {
    NSNumber *mTx;
    NSNumber *mTy;
}

@end

@implementation TilingOffset

@synthesize tx = mTx;
@synthesize ty = mTy;

- (NSDictionary *)serializeMembers {
    return @{
             @"tx":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"ty":[JWSerializeInfo objectWithClass:[NSNumber class]],
             };
}

@end
