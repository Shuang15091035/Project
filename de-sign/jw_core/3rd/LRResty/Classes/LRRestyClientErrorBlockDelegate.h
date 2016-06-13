//
//  LRRestyClientErrorBlockDelegate.h
//  LRResty
//
//  Created by macbook on 13-7-28.
//
//

#import <Foundation/Foundation.h>
#import "LRRestyClient.h"
#import "LRRestyRequestDelegate.h"

@interface LRRestyClientErrorBlockDelegate : NSObject <LRRestyRequestDelegate>
{
    LRRestyResponseBlock block;
    LRRestyErrorBlock errorBlock;
}
+ (id)delegateWithBlock:(LRRestyResponseBlock)block andErrorBlock:(LRRestyErrorBlock)errorBlock;
- (id)initWithBlock:(LRRestyResponseBlock)theBlock andErrorBlock:(LRRestyErrorBlock)theErrorBlock;
@end

