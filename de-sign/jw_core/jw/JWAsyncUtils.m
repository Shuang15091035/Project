//
//  JWAsyncUtils.m
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAsyncUtils.h"

@implementation JWAsyncUtils

+ (void)runOnMainQueue:(dispatch_block_t)block {
    [self runOnMainQueue:block withPriority:NSOperationQueuePriorityNormal];
}

+ (void)runOnMainQueue:(dispatch_block_t)block withPriority:(NSInteger)priority {
    // 调用runOnMainQueue一般是异步处理多个任务，而且是FIFO机制，
    // 故这里判断如果在主线程就直接运行了，可能会导致依赖问题
//    if ([NSThread isMainThread]) {
//        block();
//    } else {
        NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:block];
        op.queuePriority = priority;
        [[NSOperationQueue mainQueue] addOperation:op];
//    }
}

@end
