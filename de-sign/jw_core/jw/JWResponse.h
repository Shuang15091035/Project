//
//  JWResponse.h
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWNetMessage.h>
#import <jw/JWHttpMethod.h>
#import <jw/JWResponseStatus.h>
#import <jw/JWNetFormatter.h>

/**
 * 响应接口
 */
@protocol JIResponse <IJWNetMessage>

/**
 * 网络状态码
 */
@property (nonatomic, readwrite) JWResponseStatus status;

/**
 * 响应的数据
 */
@property (nonatomic, readwrite) NSData* data;

@end

/**
 * 响应对象
 */
@interface JWResponse : JWNetMessage <JIResponse>
{
    JWResponseStatus mStatus;
    NSData* mData;
}

@end
