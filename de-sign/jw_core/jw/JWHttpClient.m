//
//  JWHttpClient.m
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWHttpClient.h"
#import "JWRequest.h"
#import "JWResponse.h"
#import "JWHttp.h"
#import "JWFile.h"
#import "JWNetUtils.h"
#import "NSString+JWCoreCategory.h"

@interface JWHttpClient ()
{
    NSMutableDictionary* mParams;
    NSMutableDictionary* mHeaders;
    NSMutableDictionary* mFiles;
}

@end

@implementation JWHttpClient

- (JWAsyncResult *)sendRequest:(JWRequest *)request async:(BOOL)async onServerResponse:(void (^)(id<JIResponse>))handler
{
    JWAsyncResult* result = [JWAsyncResult result];
    
    if(![JWNetUtils isNetworkConnected])
    {
        id<JIResponse> response = [JWClientUtils createResponseFromRequest:request andStatus:JWResponseStatusNoNetWorkConnection];
        if(handler != nil)
            handler(response);
        result.syncResult = [NSNumber numberWithBool:NO];
        return result;
    }
    
    if([NSString isNilOrBlank:mUrl])
    {
        id<JIResponse> response = [JWClientUtils createResponseFromRequest:request andStatus:JWResponseStatusBadRequest];
        if(handler != nil)
            handler(response);
        result.syncResult = [NSNumber numberWithBool:NO];
        return result;
    }

    NSString* url = mUrl;
    NSString* reqUrl = request.url;
    if(![NSString isNilOrBlank:reqUrl])
    {
        if(![NSString is:reqUrl equalsTo:@"/"])
        {
            if(![NSString isNilOrBlank:mUrlSuffix])
                url = [NSString stringWithFormat:@"%@%@%@", mUrl, reqUrl, mUrlSuffix];
            else
                url = [NSString stringWithFormat:@"%@%@", mUrl, reqUrl];
        }
    }
    
    // 请求方法
    JWHttpMethod method = request.method;
    
    // 添加请求参数
    if(mParams == nil)
        mParams = [NSMutableDictionary dictionary];
    [mParams removeAllObjects];
    [request getParams:mParams];
    
    // 添加请求headers
    if(mHeaders == nil)
        mHeaders = [NSMutableDictionary dictionary];
    [mHeaders removeAllObjects];
    [request getHeaders:mHeaders];
    
    // 添加请求文件列表
    if(mFiles == nil)
        mFiles = [NSMutableDictionary dictionary];
    [mFiles removeAllObjects];
    [request getFiles:mFiles];
    
    JWHttp* http = [[JWHttp alloc] init];
    [http startWithUrl:url encoding:mEncoding];
    [http paramWithParams:mParams];
    [http headerWithHeaders:mHeaders];
    for(NSString* name in mFiles)
    {
        id<JIFile> file = [mFiles objectForKey:name];
        if(file != nil)
            [http fileWithName:name andMimeType:file.mimeType data:file.data];
    }
    [http executeWithMethod:method timeout:mTimeout async:async completionHandler:^(NSHTTPURLResponse *httpResponse, NSData *data, NSError *connectionError) {
        
        id<JIResponse> response = nil;
        if(connectionError == nil)
        {
            JWResponseStatus status = (JWResponseStatus)httpResponse.statusCode;
            response = [JWClientUtils createResponseFromRequest:request andStatus:status];
            if(data != nil)
            {
                NSString* responseString = [[NSString alloc] initWithData:data encoding:[JWEncodingUtils toNSStringEncoding:mEncoding]];
                [response deserializeString:responseString];
            }
            if(handler != nil)
                handler(response);
        }
        else
        {
            if(connectionError.code == NSURLErrorTimedOut)
                response = [JWClientUtils createResponseFromRequest:request andStatus:JWResponseStatusTimeout];
            else if(connectionError.code == NSURLErrorCannotConnectToHost)
                response = [JWClientUtils createResponseFromRequest:request andStatus:JWResponseStatusCannotConnectToHost];
            else if(connectionError.code == NSURLErrorNotConnectedToInternet)
                response = [JWClientUtils createResponseFromRequest:request andStatus:JWResponseStatusNoNetWorkConnection];
            else
                response = [JWClientUtils createResponseFromRequest:request andStatus:JWResponseStatusClientError];
            if(handler != nil)
                handler(response);
        }
        result.syncResult = response;
    }];
    
    return result;
}

@end
