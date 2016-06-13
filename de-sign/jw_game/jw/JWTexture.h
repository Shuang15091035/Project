//
//  JWTexture.h
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWResource.h>
#import <jw/JCTexture.h>
#import <jw/JWImageSystem.h>

@protocol JITexture <JIResource>

@property (nonatomic, readwrite) JCTilingOffset tilingOffset;
@property (nonatomic, readonly) JWImageOptions* options;
@property (nonatomic, readwrite) JCTextureFilter minFilter;
@property (nonatomic, readwrite) JCTextureFilter magFilter;

@property (nonatomic, readwrite) UIImage* image; // TODO 可能删除
//@property (nonatomic, readonly) JCBitmapRef bitmap;
@property (nonatomic, readonly) JCPixelFormat pixelFormat;
@property (nonatomic, readonly) NSUInteger sizeInMemory;

- (id<JITexture>) copyInstance;

@end

@interface JWTexture : JWResource <JITexture> {
    JWImageOptions* mOptions;
    JCTexture mTexture;
    UIImage* mImage;
}

@property (nonatomic, readonly) JCTexture* ctexture;

@end
