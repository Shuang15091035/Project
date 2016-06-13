//
//  JWImageCodec.h
//  June Winter
//
//  Created by GavinLo on 15/1/15.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JCImage.h>
#import <jw/JWFile.h>
#import <jw/JWImageOptions.h>

@protocol JIImageCodec <NSObject>

/**
 * codec对应的文件格式列表
 */
@property (nonatomic, readonly) NSArray* patterns;

/**
 * 解码图片
 */
- (JCImage) decodeFile:(id<JIFile>)file withOptions:(JWImageOptions*)options;

@end

@interface JWImageCodec : NSObject <JIImageCodec>

+ (id) codec;

@end


