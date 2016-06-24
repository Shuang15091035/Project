//
//  NSString+Tools.h
//  FirstBlood
//
//  Created by qianfeng on 15/9/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)
/**
 *  URL地址编码
 *
 */
NSString * URLEncodedString(NSString *str);
/**
 *  MD5生成唯一的key
 *
 */
NSString * MD5Hash(NSString *aString);

/**
 *  计算文字的高度
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
