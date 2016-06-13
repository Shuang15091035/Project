//
//  JWNetFormatter.m
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWNetFormatter.h"

@interface JWNetFormatter ()
{
    JWNetFormat mFormat;
    NSString* mKey;
}

@end

@implementation JWNetFormatter

- (JWNetFormat)format
{
    return mFormat;
}

- (void)setFormat:(JWNetFormat)format
{
    mFormat = format;
}

- (NSString *)key
{
    return mKey;
}

- (void)setKey:(NSString *)key
{
    mKey = key;
}

- (id)initWith:(JWNetFormat)format andKey:(NSString *)key
{
    self = [super init];
    if(self != nil)
    {
        mFormat = format;
        mKey = key;
    }
    return self;
}

+ (id)formatterWith:(JWNetFormat)format key:(NSString *)key
{
    return [[JWNetFormatter alloc] initWith:format andKey:key];
}

@end
