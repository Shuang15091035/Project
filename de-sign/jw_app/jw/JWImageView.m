//
//  JWImageView.m
//  jw_app
//
//  Created by ddeyes on 16/4/16.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageView.h"
#import "UIView+JWUiCategory.h"
#import "UIView+JWUiLayout.h"
#import "UIImageView+JWUiCategory.h"

@interface JWImageView () {
    UIImageView* mImageView;
}

@end

@implementation JWImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupWithImage:nil highlightedImage:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupWithImage:nil highlightedImage:nil];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        [self setupWithImage:image highlightedImage:nil];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        [self setupWithImage:image highlightedImage:highlightedImage];
    }
    return self;
}

- (void) setupWithImage:(UIImage*)image highlightedImage:(UIImage *)highlightedImage {
    if (image != nil && highlightedImage != nil) {
        mImageView = [[UIImageView alloc] initWithImage:image highlightedImage:highlightedImage];
    } else if (image != nil) {
        mImageView = [[UIImageView alloc] initWithImage:image];
    } else {
        mImageView = [[UIImageView alloc] init];
    }
    mImageView.layoutParams.width = JWLayoutWrapContent;
    mImageView.layoutParams.height = JWLayoutWrapContent;
    mImageView.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [self addSubview:mImageView];
}

- (UIImage *)image {
    return mImageView.image;
}

- (void)setImage:(UIImage *)image {
    mImageView.image = image;
}

- (UIImage *)highlightedImage {
    return mImageView.highlightedImage;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
    mImageView.highlightedImage = highlightedImage;
}

- (void)fitImageWithOptions:(JWUiFitOptions)options {
    [mImageView fitImageWithOptions:options];
    self.frameSize = mImageView.frameSize;
}

@end