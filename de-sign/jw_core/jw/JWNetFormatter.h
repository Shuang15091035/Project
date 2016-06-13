//
//  JWNetFormatter.h
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWObject.h>

typedef NS_ENUM(NSInteger, JWNetFormat)
{
    JWNetFormatJson,
};

/**
 * 格式化器
 */
@interface JWNetFormatter : JWObject

/**
 * 数据格式
 */
@property (nonatomic, readwrite) JWNetFormat format;

/**
 * 数据的key
 * 一般用于网络发送参数,且为参数列表形式时,指定这个为参数的key.
 * 如果不指定,数据会发送以指定的格式直接发送.
 */
@property (nonatomic, readwrite) NSString* key;

- (id) initWith:(JWNetFormat)format andKey:(NSString*)key;
+ (id) formatterWith:(JWNetFormat)format key:(NSString*)key;

@end
