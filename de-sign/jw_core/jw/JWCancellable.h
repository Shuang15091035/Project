//
//  JWCancellable.h
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JICancellable <NSObject>

- (void) cancel;
@property (nonatomic, readonly) BOOL isCancelled;

@end

@interface JWCancellable : NSObject <JICancellable>
{
    BOOL mIsCancelled;
}

@end