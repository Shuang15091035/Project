//
//  JWAsyncResultTask.h
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWAsyncTask.h>
#import <jw/JWAsyncResult.h>

@interface JWAsyncResultTask : JWAsyncTask
{
    JWAsyncResult* mAsyncResult;
}

- (id) initWithResult:(JWAsyncResult*)result;

@end
