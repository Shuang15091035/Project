//
//  JWRequest.h
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWNetMessage.h>
#import <jw/JWHttpMethod.h>

/**
 * 请求接口
 */
@protocol JIRequest <IJWNetMessage>

/**
 * 请求的url
 */
@property (nonatomic, readwrite) NSString* url;

/**
 * 请求的方法
 */
@property (nonatomic, readwrite) JWHttpMethod method;

/**
 * 响应对象的类型
 */
@property (nonatomic, readonly) Class responseClass;

@end

/**
 * 请求对象
 */
@interface JWRequest : JWNetMessage <JIRequest>
{
    NSString* mUrl;
    JWHttpMethod mMethod;
    Class mResponseClass;
}

@end
