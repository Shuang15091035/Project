//
//  UIButton+JWUiCategory.h
//  June Winter
//
//  Created by GavinLo on 15/1/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/UIImage+JWImageUtils.h>
#import <jw/UILabel+JWUiCategory.h>

@interface UIButton (JWUiCategory)

- (id) initWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage;
- (id) initWithImage:(UIImage*)image selectedImage:(UIImage*)selectedImage;
@property (nonatomic, readwrite) NSString* text;
@property (nonatomic, readwrite) UIColor* textColor;
//@property (nonatomic, readwrite) CGFloat textSize;
//@property (nonatomic, readwrite) JWTextStyle textStyle;
@property (nonatomic, readwrite) CGFloat buttonTextSize;
@property (nonatomic, readwrite) JWTextStyle buttonTextStyle;
- (void) setBackgroundDrawable:(NSString*)drawable;
- (void) setBackgroundDrawable:(NSString*)drawable withOptions:(JWImageOptions*)options;
- (CGSize) contentSizeWithOptions:(JWUiFitOptions)options;
- (void) fitContentWithOptions:(JWUiFitOptions)options;

@end
