//
//  LRRestyClient+GET+ERROR.m
//  LRResty
//
//  Created by macbook on 13-7-28.
//
//

#import "LRRestyClient+GET+ERROR.h"
#import "LRRestyClientProxyDelegate.h"
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyClientStreamingDelegate.h"
#import "NSObject+SynchronousProxy.h"
#import "LRRestyClientErrorBlockDelegate.h"

@implementation LRRestyClient (GET_ERROR)

#pragma mark -
#pragma mark Delegate API

#pragma mark -
#pragma mark Blocks API

//- (LRRestyRequest *)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block andErrorBlock:(LRRestyErrorBlock)errorBlock
//{
//    return [self get:urlString parameters:nil withBlock:block andErrorBlock:errorBlock];
//}
//
//- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block andErrorBlock:(LRRestyErrorBlock)errorBlock
//{
//    return [self get:urlString parameters:parameters headers:nil withBlock:block andErrorBlock:errorBlock];
//}
//
//- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block andErrorBlock:(LRRestyErrorBlock)errorBlock
//{
//    return [HTTPClient GET:[NSURL URLWithString:urlString] parameters:parameters headers:headers delegate:[LRRestyClientErrorBlockDelegate delegateWithBlock:block andErrorBlock:errorBlock]];
//}

- (LRRestyRequest *)get:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block andErrorBlock:(LRRestyErrorBlock)errorBlock
{
    return [HTTPClient GET:url parameters:parameters headers:headers delegate:[LRRestyClientErrorBlockDelegate delegateWithBlock:block andErrorBlock:errorBlock]];
}

#pragma mark -
#pragma mark Synchronous API


@end
