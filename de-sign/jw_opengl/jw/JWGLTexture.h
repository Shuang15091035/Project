//
//  JWGLTexture.h
//  June Winter
//
//  Created by GavinLo on 14/10/30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWTexture.h>
#import <jw/JWGLResource.h>

//@interface JWGLTexture : JWGLResource <JITexture>
//{
//    JWImageOptions* mOptions;
//    JCTexture mTexture;
//    UIImage* mImage;
//}
//
//@property (nonatomic, readonly) JCTexture* _texture;
//
//@end

@interface JWGLTexture : JWTexture <JIGLResource>

@property (nonatomic, readonly) JCTexture* _texture;

@end