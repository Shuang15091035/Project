//
//  JWTransmitable.h
//  June Winter
//
//  Created by GavinLo on 14-2-25.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JITransmitable <NSObject>

- (NSURL*) toUrl;
@property (nonatomic, readonly) NSString* mimeType;

@end

@interface JWTransmitable : NSObject <JITransmitable>
{
    NSString* mMimeType;
}

@end
