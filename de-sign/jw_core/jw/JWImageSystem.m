//
//  JWImageSystem.m
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageSystem.h"
#import "JWImageDecodeAsyncTask.h"

@implementation JWImageSystem

+ (id)system
{
    return [[JWImageSystem alloc] init];
}

- (NSUInteger)sizeOf:(UIImage *)image
{
    if(image == nil)
        return 0;
    
    NSUInteger width = (NSUInteger)image.size.width;
    NSUInteger Height = (NSUInteger)image.size.height;
    NSUInteger bytesPerRow = 4 * width;
    if(bytesPerRow % 16)
        bytesPerRow = ((bytesPerRow / 16) + 1) * 16;
    NSUInteger size = Height * bytesPerRow;
    return size;
}

- (UIImage *)decodeFile:(id<JIFile>)file options:(JWImageOptions *)options
{
    return [self decodeFile:file options:options async:NO onDecoded:nil].syncResult;
}

- (JWAsyncResult *)decodeFile:(id<JIFile>)file options:(JWImageOptions *)options async:(BOOL)async onDecoded:(JWImageSystemOnDecodedBlock)onDecoded
{
    JWAsyncResult* result = [JWAsyncResult result];
    JWImageDecodeAsyncTask* task = [JWImageDecodeAsyncTask taskWithFile:file options:options onImageDecode:onDecoded];
    if(!async)
    {
        [task onPreExecute];
        if(task.isCancelled)
        {
            result.syncResult = nil;
            return result;
        }
        UIImage* image = [task doInBackground:nil];
        [task onPostExecute:image];
        result.syncResult = image;
    }
    else
    {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

@end
