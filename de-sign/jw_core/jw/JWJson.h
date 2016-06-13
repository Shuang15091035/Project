//
//  JWJson.h
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWObject.h>
#import <jw/JWEncoding.h>

/**
 * NSObject序列化JSON的规则为
 * [NSNumber numberWithBool:YES] => "true"
 * [NSNumber numberWithBool:NO] => "false"
 * NSNumber => json number
 * NSString => json string
 * NSArray => json array
 */
@interface JWJson : NSObject

+ (NSDictionary*) deserializeData:(NSData*)data error:(NSError**)error;

+ (void) fromJson:(id<JISerializeObject>)object serializeMethod:(NSInteger)methodId withString:(NSString*)string encoding:(JWEncoding)encoding error:(NSError**)error;
+ (NSString*) toJson:(id<JISerializeObject>)object serializeMethod:(NSInteger)methodId encoding:(JWEncoding)encoding error:(NSError**)error;

@end
