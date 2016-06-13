//
//  JWHttp.m
//  June Winter
//
//  Created by GavinLo on 14-2-22.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWHttp.h"
#import "JWFile.h"
#import "NSString+JWCoreCategory.h"

@implementation JWFileInfo

@synthesize mimeType;
@synthesize data;

@end

@interface JWHttp ()
{
    NSString* mUrl;
    JWEncoding mEncoding;
    NSMutableDictionary* mParams;
    NSMutableDictionary* mHeaders;
    NSMutableDictionary* mFiles;
}

@property (nonatomic, readonly) NSMutableDictionary* params;
@property (nonatomic, readonly) NSMutableDictionary* headers;
@property (nonatomic, readonly) NSMutableDictionary* files;

@end

@implementation JWHttp

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

- (JWHttp *)startWithUrl:(NSString *)url encoding:(JWEncoding)encoding
{
    mUrl = url;
    mEncoding = encoding;
    return self;
}

- (JWHttp *)paramWithName:(NSString *)name andValue:(NSString *)value
{
    NSMutableDictionary* params = self.params;
    [params setObject:name forKey:value];
    return self;
}

- (JWHttp *)paramWithParams:(NSDictionary *)params
{
    [self.params addEntriesFromDictionary:params];
    return self;
}

- (JWHttp *)headerWithHeaders:(NSDictionary *)headers
{
    [self.headers addEntriesFromDictionary:headers];
    return self;
}

- (JWHttp *)fileWithName:(NSString *)name andMimeType:(NSString *)type data:(NSData *)data
{
    NSMutableDictionary* files = self.files;
    JWFileInfo* fileInfo = [[JWFileInfo alloc] init];
    fileInfo.mimeType = type;
    fileInfo.data = data;
    [files setObject:fileInfo forKey:name];
    return self;
}

- (void)executeWithMethod:(JWHttpMethod)method timeout:(NSTimeInterval)timeout async:(BOOL)async completionHandler:(void (^)(NSHTTPURLResponse *, NSData *, NSError *))handler
{
    [JWHttpUtils executeWithUrl:mUrl method:method encoding:mEncoding timeout:timeout params:mParams headers:mHeaders files:mFiles async:async completionHandler:handler];
}

+ (NSString*) MultipartBoundary
{
    return @"yuzhou_network";
}

- (NSMutableDictionary *)params
{
    if(mParams == nil)
        mParams = [NSMutableDictionary dictionary];
    return mParams;
}

- (NSMutableDictionary *)headers
{
    if(mHeaders == nil)
        mHeaders = [NSMutableDictionary dictionary];
    return mHeaders;
}

- (NSMutableDictionary *)files
{
    if(mFiles == nil)
        mFiles = [NSMutableDictionary dictionary];
    return mFiles;
}

@end

@implementation JWHttpUtils

+ (void)executeWithUrl:(NSString *)url method:(JWHttpMethod)method encoding:(JWEncoding)encoding timeout:(NSTimeInterval)timeout params:(NSDictionary *)params headers:(NSDictionary *)headers files:(NSDictionary *)files async:(BOOL)async completionHandler:(void (^)(NSHTTPURLResponse *, NSData *, NSError *))handler
{
    if(!async)
    {
        [self executeSyncWithUrl:url method:method encoding:encoding timeout:timeout params:params headers:headers files:files completionHandler:handler];
    }
    else
    {
        [self executeAsyncWithUrl:url method:method encoding:encoding timeout:timeout params:params headers:headers files:files completionHandler:handler];
    }
}

+ (void)executeSyncWithUrl:(NSString*)url method:(JWHttpMethod)method encoding:(JWEncoding)encoding timeout:(NSTimeInterval)timeout params:(NSDictionary *)params headers:(NSDictionary *)headers files:(NSDictionary *)files completionHandler:(void (^)(NSHTTPURLResponse *, NSData *, NSError *))handler
{
    NSURLRequest* request = [self getRequestFromUrl:url method:method encoding:encoding timeout:timeout params:params headers:headers files:files];
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(handler != nil)
        handler((NSHTTPURLResponse*)response, data, error);
}

+ (void)executeAsyncWithUrl:(NSString*)url method:(JWHttpMethod)method encoding:(JWEncoding)encoding timeout:(NSTimeInterval)timeout params:(NSDictionary *)params headers:(NSDictionary *)headers files:(NSDictionary *)files completionHandler:(void (^)(NSHTTPURLResponse *, NSData *, NSError *))handler
{
    NSURLRequest* request = [self getRequestFromUrl:url method:method encoding:encoding timeout:timeout params:params headers:headers files:files];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(handler != nil)
            handler((NSHTTPURLResponse*)response, data, connectionError);
    }];
}

+ (NSURLRequest*) getRequestFromUrl:(NSString*)url method:(JWHttpMethod)method encoding:(JWEncoding)encoding timeout:(NSTimeInterval)timeout params:(NSDictionary *)params headers:(NSDictionary *)headers files:(NSDictionary *)files
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    
    // 设置url,不同的method组合不同的url
    NSString* reqUrl = url;
    
    // 处理请求
    switch(method)
    {
        case JWHttpMethodGet:
        {
            [request setHTTPMethod:@"GET"];
            NSString* query = [self getQueryFromParams:params];
            if(query != nil)
                url = [NSString stringWithFormat:@"%@?%@", reqUrl, query];
            break;
        }
        case JWHttpMethodPost:
        {
            [request setHTTPMethod:@"POST"];
            NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [JWHttp MultipartBoundary]];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
            NSData* body = [self getMultipartBodyWithParams:params files:files encoding:encoding];
            [request setHTTPBody:body];
            break;
        }
    }
    request.URL = [NSURL URLWithString:reqUrl];
    
    // 处理headers
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(obj == [NSNull null])
            return;
        NSString* headerName = key;
        NSString* headerValue = obj;
        [request setValue:headerValue forHTTPHeaderField:headerName];
    }];
    
    // 设置超时
    [request setTimeoutInterval:timeout];
    
    return request;
}

+ (NSData*) getMultipartBodyWithParams:(NSDictionary *)params files:(NSDictionary *)files encoding:(JWEncoding)encoding
{
    NSMutableData* body = [NSMutableData data];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(obj == [NSNull null])
            return;
        NSString* value = obj;
        NSData* paramData = [self getDataWithKey:key value:value encoding:encoding];
        if(paramData != nil)
            [body appendData:paramData];
    }];
    
    [files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(obj == [NSNull null])
            return;
        JWFileInfo* fileInfo = obj;
        NSData* fileData = [self getDataWithFileInfo:fileInfo name:key encoding:encoding];
        if(fileData != nil)
            [body appendData:fileData];
    }];
    
    // 参数结束标记
    if(body.length > 0)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@--", [JWHttp MultipartBoundary]] dataUsingEncoding:[JWEncodingUtils toNSStringEncoding:encoding]]];
    }
    return body;
}

+ (NSData*) getDataWithKey:(NSString*)key value:(NSString*)value encoding:(JWEncoding)encoding
{
    if(key == nil || value == nil)
        return nil;
    
    // 普通参数标记
    NSString* param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data; name=\"%@\"\r\n\r\n%@\r\n", [JWHttp MultipartBoundary], key, value];
    return [param dataUsingEncoding:[JWEncodingUtils toNSStringEncoding:encoding]];
}

+ (NSData*) getDataWithFileInfo:(JWFileInfo*)fileInfo name:(NSString*)name encoding:(JWEncoding)encoding
{
    if(fileInfo == nil || name == nil)
        return nil;
    if(fileInfo.mimeType == nil || fileInfo.data == nil)
        return nil;
    
    // 文件标记
    NSString* fileName = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type:%@\r\n\r\n", [JWHttp MultipartBoundary], name, name, fileInfo.mimeType];
    NSMutableData* file = [NSMutableData data];
    [file appendData:[fileName dataUsingEncoding:[JWEncodingUtils toNSStringEncoding:encoding]]];
    [file appendData:fileInfo.data];
    [file appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:[JWEncodingUtils toNSStringEncoding:encoding]]];
    return file;
}

+ (NSString*) getQueryFromParams:(NSDictionary*)params
{
    if(params == nil)
        return nil;
    
    NSMutableString* query = [[NSMutableString alloc] init];
    BOOL and = NO;
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(obj == [NSNull null])
            return;
        NSString* format = @"%@=%@";
        if(and)
            format = @"&%@=%@";
        
        NSString* value = [params objectForKey:key];
        if(value != nil)
            [query appendFormat:format, key, [value urlEncode]];
    }];
    return query;
}

@end
