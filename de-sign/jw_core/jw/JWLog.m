//
//  JWLog.m
//  June Winter
//
//  Created by GavinLo on 14-3-6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWLog.h"
#import "JWToast.h"

@implementation JWLog

@synthesize detailLevel = mDetailLevel;
@synthesize messageLevel = mMessageLevel;

- (id)init
{
    return [self initWithLevel:JWLogLevelNormal];
}

+ (id)log
{
    return [[JWLog alloc] init];
}

- (id)initWithLevel:(JWLogLevel)detailLevel
{
    self = [super init];
    if(self != nil)
    {
        mDetailLevel = detailLevel;
        mMessageLevel = JWLogLevelNormal;
        mType = JWLogTypeSystem;
    }
    return self;
}

+ (id)logWithLevel:(JWLogLevel)detailLevel
{
    return [[JWLog alloc] initWithLevel:detailLevel];
}

- (id<JILog>)withLevel:(JWLogLevel)messageLevel
{
    mMessageLevel = messageLevel;
    return self;
}

- (id<JILog>)withType:(JWLogType)type
{
    mType = type;
    return self;
}

- (id<JILog>)log:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    switch(mMessageLevel)
    {
        case JWLogLevelLow:
        case JWLogLevelNormal:
        case JWLogLevelCritical:
        {
            [self log:mType format:format arguments:args];
            break;
        }
    }
    va_end(args);
    return self;
}

- (void) log:(JWLogType)type format:(NSString*)format arguments:(va_list)args
{
    switch(type)
    {
        case JWLogTypeSystem:
        {
            NSLogv(format, args);
            break;
        }
        case JWLogTypeUi:
        {
            if(mLogUi == nil)
                NSLogv(format, args);
            else
            {
                NSString* message = [[NSString alloc] initWithFormat:format arguments:args];
                mLogUi.message = message;
            }
            break;
        }
    }
}

@synthesize logUi = mLogUi;

@end

@implementation JWToastLogUi

+ (id)logUi
{
    return [[JWToastLogUi alloc] init];
}

- (NSString *)message
{
    // not implement
    return nil;
}

- (void)setMessage:(NSString *)message
{
    [[JWToast makeText:message] show];
}

@end
