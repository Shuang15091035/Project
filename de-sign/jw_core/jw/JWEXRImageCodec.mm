//
//  JWEXRImageCodec.m
//  jw_core
//
//  Created by ddeyes on 15/11/23.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWEXRImageCodec.h"
#import <jw/jw_exr.h>
#import <jw/JWCoreUtils.h>

@implementation JWEXRImageCodec

- (NSArray *)patterns {
    return [NSArray arrayWithObjects:
            @"[\\w\\W]*.[eE][xX][rR]",
            nil];
}

- (JCImage)decodeFile:(id<JIFile>)file withOptions:(JWImageOptions *)options {
    JWEXRImage* exrImage = [[JWEXRImage alloc] init];
    if (![exrImage loadFile:file]) {
        return JCImageNull();
    }
    JCImage image = JCImageMake();
    JCBitmap bitmap = exrImage.bitmap;
    JCImageAddBitmap(&image, 0, &bitmap, true);
    return image;
}

@end
