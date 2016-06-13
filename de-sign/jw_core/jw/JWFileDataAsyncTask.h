//
//  JWFileDataAsyncTask.h
//  June Winter
//
//  Created by GavinLo on 14-2-28.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWAsyncTask.h>
#import <jw/JWFile.h>

@interface JWFileDataAsyncTask : JWAsyncTask

@property (nonatomic, readwrite) id<JIFile> file;
@property (nonatomic, readwrite) JWFileOnDataBlock onFileData;

- (id) initWithFile:(id<JIFile>)file onFileData:(JWFileOnDataBlock)onFileData;
+ (id) taskWithFile:(id<JIFile>)file onFileData:(JWFileOnDataBlock)onFileData;

@end
