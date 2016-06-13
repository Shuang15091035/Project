//
//  JWHashcode.m
//  June Winter
//
//  Created by GavinLo on 14-3-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWHashcode.h"

@interface JWHashcode ()
{
    NSUInteger mResult;
}

@property (nonatomic, readwrite) NSUInteger result;

@end

@implementation JWHashcode

@synthesize result = mResult;

+ (JWHashcode *)beginWith:(NSUInteger)i
{
    JWHashcode* hashcode = [[JWHashcode alloc] init];
    hashcode.result = i;
    return hashcode;
}

+ (JWHashcode *)begin
{
    return [JWHashcode beginWith:17];
}

- (JWHashcode *)atObject:(id)object
{
    NSUInteger hc = object == nil ? 0 : [object hash];
    mResult = 31 * mResult + hc;
    return self;
}

- (NSUInteger)end
{
    return mResult;
}

@end
