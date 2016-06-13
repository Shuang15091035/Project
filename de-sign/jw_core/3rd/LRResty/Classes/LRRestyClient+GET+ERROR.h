//
//  LRRestyClient+GET+ERROR.h
//  LRResty
//
//  Created by macbook on 13-7-28.
//
//

#import "LRRestyClient.h"
#import "LRRestyTypes.h"

@class LRRestyRequest;

@interface LRRestyClient (GET_ERROR)

/// ---------------------------------
/// @name Making GET requests
/// ---------------------------------

#pragma mark -
#pragma mark Delegate API


#pragma mark -
#pragma mark Blocks API

///**
// Performs a GET request on URL with block response handling.
// @param urlString   The URL to request.
// @param block       The response handler.
// @param errorBlock  The error handler.
// @returns The request object.
// */
//- (LRRestyRequest *)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block andErrorBlock:(LRRestyErrorBlock)errorBlock;
//
///**
// Performs a GET request on URL with the specified query parameters block response handling.
// @param urlString   The URL to request.
// @param parameters  A dictionary of query string parameters.
// @param block       The response handler.
// @param errorBlock  The error handler.
// @returns The request object.
// */
//- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block  andErrorBlock:(LRRestyErrorBlock)errorBlock;
//
///**
// Performs a GET request on URL with block response handling.
// @param urlString   The URL to request.
// @param parameters  A dictionary of query string parameters.
// @param headers     A dictionary of HTTP request headers.
// @param block       The response handler.
// @param errorBlock  The error handler.
// @returns The request object.
// */
//- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block  andErrorBlock:(LRRestyErrorBlock)errorBlock;

/**
 Performs a GET request on URL with block response handling.
 @param url   The URL to request.
 @param parameters  A dictionary of query string parameters.
 @param headers     A dictionary of HTTP request headers.
 @param block       The response handler.
 @param errorBlock  The error handler.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block  andErrorBlock:(LRRestyErrorBlock)errorBlock;


#pragma mark -
#pragma mark Synchronous API

@end
