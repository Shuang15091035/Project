//
//  JWLog.h
//  June Winter
//
//  Created by GavinLo on 14-3-6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

typedef NS_ENUM(NSInteger, JWLogLevel)
{
    JWLogLevelLow = 0,
    JWLogLevelNormal,
    JWLogLevelCritical,
};

typedef NS_ENUM(NSInteger, JWLogType)
{
    JWLogTypeSystem = 0, // 系统log机制
    JWLogTypeUi, // 使用Ui控件显示log
};

@protocol JILogUi;

@protocol JILog <JIObject>

@property (nonatomic, readwrite) JWLogLevel detailLevel;
@property (nonatomic, readwrite) JWLogLevel messageLevel;

- (id<JILog>) withLevel:(JWLogLevel)messageLevel;
- (id<JILog>) withType:(JWLogType)type;
- (id<JILog>) log:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);

@property (nonatomic, readwrite) id<JILogUi> logUi;

@end

@interface JWLog : JWObject <JILog>
{
    JWLogLevel mDetailLevel;
    JWLogLevel mMessageLevel;
    JWLogType mType;
    id<JILogUi> mLogUi;
}

+ (id) log;
- (id) initWithLevel:(JWLogLevel)detailLevel;
+ (id) logWithLevel:(JWLogLevel)detailLevel;

@end

@protocol JILogUi <NSObject>

@property (nonatomic, readwrite) NSString* message;

@end

@interface JWToastLogUi : NSObject <JILogUi>

+ (id) logUi;

@end
