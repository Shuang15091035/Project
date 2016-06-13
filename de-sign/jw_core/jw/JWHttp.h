//
//  JWHttp.h
//  June Winter
//
//  Created by GavinLo on 14-2-22.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWEncoding.h>
#import <jw/JWHttpMethod.h>

/**
 * http
 */
@interface JWHttp : NSObject

@property (nonatomic, readwrite) NSString* url;
@property (nonatomic, readwrite) JWHttpMethod method;

- (JWHttp*) startWithUrl:(NSString*)url encoding:(JWEncoding)encoding;
- (JWHttp*) paramWithName:(NSString*)name andValue:(NSString*)value;
- (JWHttp*) paramWithParams:(NSDictionary*)params;
- (JWHttp*) headerWithHeaders:(NSDictionary*)headers;
- (JWHttp*) fileWithName:(NSString*)name andMimeType:(NSString*)type data:(NSData*)data;

- (void) executeWithMethod:(JWHttpMethod)method timeout:(NSTimeInterval)timeout async:(BOOL)async completionHandler:(void (^)(NSHTTPURLResponse* response, NSData* data, NSError* error))handler;

@end

/**
 * 文件信息
 */
@interface JWFileInfo : NSObject

@property (nonatomic, readwrite) NSString* mimeType;
@property (nonatomic, readwrite) NSData* data;

@end

@interface JWHttpUtils : NSObject

+ (void) executeWithUrl:(NSString*)url method:(JWHttpMethod)method encoding:(JWEncoding)encoding timeout:(NSTimeInterval)timeout params:(NSDictionary *)params headers:(NSDictionary *)headers files:(NSDictionary *)files async:(BOOL)async completionHandler:(void (^)(NSHTTPURLResponse *, NSData *, NSError *))handler;

@end