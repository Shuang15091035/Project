//
//  JWStateMessage.h
//  June Winter
//
//  Created by GavinLo on 14-3-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JIStateMessage <NSObject>

@property (nonatomic, readwrite) NSInteger message;
@property (nonatomic, readwrite) id extra;
@property (nonatomic, readwrite, getter = isHandle) BOOL handle;

@end

@interface JWStateMessage : NSObject <JIStateMessage>
{
    NSInteger mMessage;
    id mExtra;
    BOOL mHandle;
}

- (id) initWithMessage:(NSInteger)message extra:(id)extra;
+ (id) messageWithMessage:(NSInteger)message extra:(id)extra;

@end
