//
//  JWFileDataAsyncTask.m
//  June Winter
//
//  Created by GavinLo on 14-2-28.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWFileDataAsyncTask.h"

@interface JWFileDataAsyncTask()
{
    JWFileOnDataBlock mOnFileData;
}

@end

@implementation JWFileDataAsyncTask

@synthesize file = mFile;

- (JWFileOnDataBlock)onFileData
{
    return mOnFileData;
}

- (void)setOnFileData:(JWFileOnDataBlock)onFileData
{
    mOnFileData = onFileData;
}

- (id)initWithFile:(id<JIFile>)file onFileData:(JWFileOnDataBlock)onFileData
{
    self = [super init];
    if(self != nil)
    {
        mFile = file;
        mOnFileData = onFileData;
    }
    return self;
}

+ (id)taskWithFile:(id<JIFile>)file onFileData:(JWFileOnDataBlock)onFileData
{
    return [[JWFileDataAsyncTask alloc] initWithFile:file onFileData:onFileData];
}

- (void)onPreExecute
{
    if(mFile == nil)
        [self cancel];
}

- (id)doInBackground:(NSArray *)params
{
    return mFile.data;
}

- (void)onPostExecute:(id)result
{
    if(mOnFileData != nil)
        mOnFileData(result, nil);
}

@end
