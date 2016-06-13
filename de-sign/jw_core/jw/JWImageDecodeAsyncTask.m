//
//  JWImageDecodeAsyncTask.m
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageDecodeAsyncTask.h"

@interface JWImageDecodeAsyncTask ()
{
    id<JIFile> mFile;
    JWImageOptions* mOptions;
    JWImageSystemOnDecodedBlock mOnImageDecode;
}

@end

@implementation JWImageDecodeAsyncTask

@synthesize file = mFile;

- (JWImageSystemOnDecodedBlock)onImageDecode
{
    return mOnImageDecode;
}

- (void)setOnImageDecode:(JWImageSystemOnDecodedBlock)onImageDecode
{
    mOnImageDecode = onImageDecode;
}

- (id)initWithFile:(id<JIFile>)file options:(JWImageOptions *)options onImageDecode:(JWImageSystemOnDecodedBlock)onImageDecode
{
    self = [super init];
    if(self != nil)
    {
        mFile = file;
        mOptions = options;
        mOnImageDecode = onImageDecode;
    }
    return self;
}

+ (id)taskWithFile:(id<JIFile>)file options:(JWImageOptions *)options onImageDecode:(JWImageSystemOnDecodedBlock)onImageDecode
{
    return [[JWImageDecodeAsyncTask alloc] initWithFile:file options:options onImageDecode:onImageDecode];
}

- (void)onPreExecute
{
    if(mFile == nil)
        [self cancel];
}

- (id)doInBackground:(NSArray *)params
{
    UIImage* image = nil;
//    if (mFile.type == JWFileTypeBundle) {
//        image = [UIImage imageNamed:mFile.path];
//    } else
    if (mFile.type == JWFileTypeMemory && [mFile.content isKindOfClass:[UIImage class]]) {
        image = mFile.content;
    } else {
        NSData* data = [mFile data];
        if(data == nil)
        {
            [self cancel];
            return image;
        }
        image = [UIImage imageWithData:data];
    }
    image = [image imageByOptions:mOptions];
    return image;
}

- (void)onPostExecute:(id)result
{
    if(result != nil)
    {
        if(mOnImageDecode != nil)
            mOnImageDecode(result); 
    }
}

@end
