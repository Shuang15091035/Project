//
//  JWClient.m
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWClient.h"
#import "JWRequest.h"
#import "JWResponse.h"

@implementation JWClient

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        mEncoding = JWEncodingUTF8;
    }
    return self;
}

- (NSString *)url
{
    return mUrl;
}

- (void)setUrl:(NSString *)url
{
    mUrl = url;
}

- (NSString *)urlSuffix
{
    return mUrlSuffix;
}

- (void)setUrlSuffix:(NSString *)urlSuffix
{
    mUrlSuffix = urlSuffix;
}

- (JWEncoding)encoding
{
    return mEncoding;
}

- (void)setEncoding:(JWEncoding)encoding
{
    mEncoding = encoding;
}

@end

@implementation JWRPCClient

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        mTimeout = 240;
    }
    return self;
}

- (NSTimeInterval)timeout
{
    return mTimeout;
}

- (void)setTimeout:(NSTimeInterval)timeout
{
    mTimeout = timeout;
}

- (JWAsyncResult *)sendRequest:(JWRequest *)request async:(BOOL)async onServerResponse:(void (^)(id<JIResponse>))handler
{
    // TODO 没有android那样的异步机制,故暂不实现,有子类实现
    return nil;
}

@end

@implementation JWClientUtils

+ (id<JIResponse>)createResponseFromRequest:(id<JIRequest>)request andStatus:(JWResponseStatus)status
{
    if(request == nil)
        return nil;
    
    Class resClass = request.responseClass;
    if(resClass == nil)
        return nil;
    
    id<JIResponse> response = [resClass new];
    response.status = status;
    return response;
}

@end