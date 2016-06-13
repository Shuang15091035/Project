//
//  JWAsyncTask.m
//  June Winter
//
//  Created by GavinLo on 14-2-28.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAsyncTask.h"
#import "JWAsyncUtils.h"

static NSOperationQueue* JW_global_queue = nil;

@implementation JWAsyncTask

- (void)execute:(NSArray *)params
{
    [self onPreExecute];
    if(self.isCancelled)
        return;
    
    // 使用系统的GCD(Grand Central Dispatch)机制来实现异步任务
    // 创建一个全局的NSOperationQueue
    if(JW_global_queue == nil)
        JW_global_queue = [[NSOperationQueue alloc] init];
    [JW_global_queue addOperationWithBlock:^{
        [self doExecute:params];
    }];
}

- (void)doExecute:(NSArray *)params
{
    if(self.isCancelled)
        return;
    id result = [self doInBackground:params];
    if(self.isCancelled)
        return;
    [self performSelectorOnMainThread:@selector(doPostExecute:) withObject:result waitUntilDone:NO];
}

- (void) doPostExecute:(id)result
{
    if(self.isCancelled)
        return;
    [self onPostExecute:result];
}

- (void)onPreExecute
{
    
}

- (id)doInBackground:(NSArray *)params
{
    return nil;
}

- (void)onPostExecute:(id)result
{
    
}

@end
