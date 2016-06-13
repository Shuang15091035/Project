//
//  JWImageDecodeAsyncTask.h
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWAsyncTask.h>
#import <jw/JWImageSystem.h>

@interface JWImageDecodeAsyncTask : JWAsyncTask

@property (nonatomic, readwrite) id<JIFile> file;
@property (nonatomic, readwrite) JWImageSystemOnDecodedBlock onImageDecode;

- (id) initWithFile:(id<JIFile>)file options:(JWImageOptions*)options onImageDecode:(JWImageSystemOnDecodedBlock)onImageDecode;
+ (id) taskWithFile:(id<JIFile>)file options:(JWImageOptions*)options onImageDecode:(JWImageSystemOnDecodedBlock)onImageDecode;

@end
