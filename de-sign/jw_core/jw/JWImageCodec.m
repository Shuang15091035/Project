//
//  JWImageCodec.m
//  June Winter
//
//  Created by GavinLo on 15/1/15.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageCodec.h"

@implementation JWImageCodec

+ (id)codec {
    return [[self alloc] init];
}

- (NSArray *)patterns {
    return nil;
}

- (JCImage)decodeFile:(id<JIFile>)file withOptions:(JWImageOptions *)options {
    return JCImageNull();
}

@end
