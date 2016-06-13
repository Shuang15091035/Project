//
//  JWGL20VideoTexture.h
//  jw_opengl
//
//  Created by ddeyes on 16/2/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWVideoTexture.h>
#import <jw/JWGL20Texture.h>
#import <jw/JWCameraCapturer.h>

@interface JWGL20VideoTexture : JWGL20Texture <JIVideoTexture, JICameraSampleHandler>

@property (nonatomic, readonly) JCTexture* yTexture;
@property (nonatomic, readonly) JCTexture* uvTexture;

@end
