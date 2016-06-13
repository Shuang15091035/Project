//
//  JWEXRImage.h
//  June Winter
//
//  Created by ddeyes on 15/11/24.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/jw_core.h>

@interface JWEXRImage : JWObject

@property (nonatomic, readonly) id<JIFile> file;
@property (nonatomic, readonly) JCBitmap bitmap;

- (BOOL) loadFile:(id<JIFile>)file;

@end
