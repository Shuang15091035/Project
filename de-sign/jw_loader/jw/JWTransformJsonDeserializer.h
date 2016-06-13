//
//  JWTransformJsonDeserializer.h
//  June Winter
//
//  Created by GavinLo on 15/1/14.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JCTransform.h>

@interface JWTransformJsonDeserializer : NSObject

+ (JCTransform) cTransformFrom:(NSDictionary*)jsonObject;

@end
