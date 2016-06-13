//
//  UIImageImageCodec.m
//  June Winter
//
//  Created by GavinLo on 15/1/16.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "UIImageImageCodec.h"
#import "JWCorePluginSystem.h"
#import <jw/JCUtils.h>

@implementation UIImageImageCodec

- (NSArray *)patterns {
    return @[
             @"[\\w\\W]*.[jJ][pP][gG]",
             @"[\\w\\W]*.[jJ][pP][eE][gG]",
             @"[\\w\\W]*.[pP][nN][gG]",
             ];
}

- (JCImage)decodeFile:(id<JIFile>)file withOptions:(JWImageOptions *)options {
    UIImage* uiImage = [[JWCorePluginSystem instance].imageSystem decodeFile:file options:options];
    if(uiImage == nil)
        return JCImageNull();
    JCBitmap bitmap = [uiImage bitmapScalePowerOf2:NO]; // NOTE 这里会调用JCMemoryClone
    if (bitmap.data.data == NULL) {
        return JCImageNull();
    }
    
    JCImage image = JCImageMake();
    JCImageAddBitmap(&image, 0, &bitmap, true);
    return image;
}

@end
