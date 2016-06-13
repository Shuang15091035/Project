//
//  JWAsyncTaskResult.h
//  June Winter
//
//  Created by GavinLo on 14/11/4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWAsyncResult.h>
#import <jw/JWAsyncTask.h>

@interface JWAsyncTaskResult : JWAsyncResult
{
    JWAsyncTask* mAsyncTask;
}

@property (nonatomic, readwrite) JWAsyncTask* asyncTask;

@end
