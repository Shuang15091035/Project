//
//  LRRestyClientErrorBlockDelegate.m
//  LRResty
//
//  Created by macbook on 13-7-28.
//
//

#import "LRRestyClientErrorBlockDelegate.h"

@implementation LRRestyClientErrorBlockDelegate

+ (id)delegateWithBlock:(LRRestyResponseBlock)block andErrorBlock:(LRRestyErrorBlock)errorBlock
{
    return [[self alloc] initWithBlock:block andErrorBlock:errorBlock];
}

- (id)initWithBlock:(LRRestyResponseBlock)theBlock andErrorBlock:(LRRestyErrorBlock)theErrorBlock
{
    if ((self = [super init])) {
        block = [theBlock copy];
        errorBlock = [theErrorBlock copy];
    }
    return self;
}


- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response
{
    if (block) {
        block(response);
    }
}

- (void)restyRequest:(LRRestyRequest *)request didFailWithError:(NSError *)error
{
    if(errorBlock){
        errorBlock(error);
    }
}

@end
