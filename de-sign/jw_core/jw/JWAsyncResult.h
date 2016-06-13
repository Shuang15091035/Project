//
//  JWAsyncResult.h
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWCancellable.h>

/**
 * 异步结果
 */
@interface JWAsyncResult : JWCancellable

@property (nonatomic, readwrite) id syncResult;

+ (id) result;

@end
