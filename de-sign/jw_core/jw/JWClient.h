//
//  JWClient.h
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWEncoding.h>
#import <jw/JWObject.h>
#import <jw/JWAsyncResult.h>
#import <jw/JWRequest.h>
#import <jw/JWResponse.h>

/**
 * 一般客户端
 */
@protocol JIClient <JIObject>

/**
 * url,基础的url,它会与IJWRequest中的url组合成最终的url.
 * 组合的规则为: url + reqUrl + urlSuffix
 */
@property (nonatomic, readwrite) NSString* url;

/**
 * url后缀,是最终url的一部分
 */
@property (nonatomic, readwrite) NSString* urlSuffix;

/**
 * 发送请求时的编码方式,默认为UTF-8
 */
@property (nonatomic, readwrite) JWEncoding encoding;

@end

@interface JWClient : JWObject <JIClient>
{
    NSString* mUrl;
    NSString* mUrlSuffix;
    JWEncoding mEncoding;
}

@end

/**
 * (Remote Procedure Call)客户端,发送请求参数,获取返回,类似过程调用的客户端封装
 */
@protocol JIRPCClient <JIClient>

/**
 * 请求的超时时间,单位秒.
 * 根据Apple官方规定,iOS 6默认以及最低的timeout时间为240秒.
 * 详情请查看:https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/nsmutableurlrequest_Class/Reference/Reference.html#//apple_ref/occ/instm/NSMutableURLRequest/setTimeoutInterval:
 */
@property (nonatomic, readwrite) NSTimeInterval timeout;

/**
 * 同步/异步发送请求
 * @param request 请求
 * @param async 是否异步发送
 * @param handler 请求返回的处理函数
 */
- (JWAsyncResult*) sendRequest:(JWRequest*)request async:(BOOL)async onServerResponse:(void (^)(id<JIResponse> response))handler;

@end

@interface JWRPCClient : JWClient <JIRPCClient>
{
    NSTimeInterval mTimeout;
}

@end

// Utils
@interface JWClientUtils : NSObject

+ (id<JIResponse>) createResponseFromRequest:(id<JIRequest>)request andStatus:(JWResponseStatus)status;

@end