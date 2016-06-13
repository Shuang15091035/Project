//
//  JWTexture.m
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWTexture.h"
#import "JWCorePluginSystem.h"

@implementation JWTexture

- (void)onCreate
{
    [super onCreate];
    mTexture = JCTextureMake();
}

- (JCTilingOffset)tilingOffset {
    return mTexture.st;
}

- (void)setTilingOffset:(JCTilingOffset)tilingOffset {
    mTexture.st = tilingOffset;
}

- (JWImageOptions *)options
{
    if(mOptions == nil)
        mOptions = [JWImageOptions options];
    return mOptions;
}

- (JCTextureFilter)minFilter
{
    return mTexture.minFilter;
}

- (void)setMinFilter:(JCTextureFilter)minFilter
{
    mTexture.minFilter = minFilter;
}

- (JCTextureFilter)magFilter
{
    return mTexture.magFilter;
}

- (void)setMagFilter:(JCTextureFilter)magFilter
{
    mTexture.magFilter = magFilter;
}

- (UIImage *)image
{
    return mImage;
}

- (void)setImage:(UIImage *)image
{
    if(image == nil)
        return;
    if(image == mImage)
        return;
    
    [self unloadResource];
    
    mImage = image;
    if(mFile == nil)
        mFile = [JWFile file];
    mFile.type = JWFileTypeMemory;
    mFile.content = image;
    
    self.state = JWResourceStateValid;
}

//- (JCBitmapRef)bitmap {
//    return &mTexture.bitmap;
//}

- (JCPixelFormat)pixelFormat {
    return JCPixelFormat_Unknown;
}

- (NSUInteger)sizeInMemory {
    // TODO
    return 0;
}

- (id<JITexture>)copyInstance {
    // subclass override
    return nil;
}

- (BOOL)loadFile:(id<JIFile>)file
{
    mImage = [[JWCorePluginSystem instance].imageSystem decodeFile:mFile options:mOptions];
    return mImage != nil;
}

- (JCTexture *)ctexture {
    return &mTexture;
}

@end
