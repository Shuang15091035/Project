//
//  JWImageSystem.h
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWObject.h>
#import <jw/JWFile.h>
#import <jw/JWAsyncResult.h>
#import <jw/UIImage+JWImageUtils.h>

typedef void (^JWImageSystemOnDecodedBlock)(UIImage* image);

/**
 * 图片系统(包括解码等操作)
 */
@protocol JIImageSystem <JIObject>

- (NSUInteger) sizeOf:(UIImage*)image;
- (UIImage*) decodeFile:(id<JIFile>)file options:(JWImageOptions*)options;
- (JWAsyncResult*) decodeFile:(id<JIFile>)file options:(JWImageOptions*)options async:(BOOL)async onDecoded:(JWImageSystemOnDecodedBlock)onDecoded;

@end

@interface JWImageSystem : JWObject <JIImageSystem>

+ (id) system;

@end
