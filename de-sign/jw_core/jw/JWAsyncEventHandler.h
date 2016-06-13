//
//  JWAsyncEventHandler.h
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWAsyncUtils.h>

@interface JWAsyncEventHandler : JWObject {
    BOOL mAsync;
}

@property (nonatomic, readwrite) BOOL async;

- (id) initWithAsync:(BOOL)async;

@end
