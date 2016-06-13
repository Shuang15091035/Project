//
//  JWImageView.h
//  jw_app
//
//  Created by ddeyes on 16/4/16.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWFrameLayout.h>
#import <jw/JWUiCommon.h>

@interface JWImageView : JWFrameLayout

- (id)initWithImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage;

@property (nonatomic, readwrite) UIImage* image;
@property (nonatomic, readwrite) UIImage* highlightedImage;
- (void) fitImageWithOptions:(JWUiFitOptions)options;

@end
