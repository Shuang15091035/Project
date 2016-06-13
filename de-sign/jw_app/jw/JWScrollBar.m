//
//  JWScrollBar.m
//  jw_app
//
//  Created by ddeyes on 16/4/22.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWScrollBar.h"
#import "UIView+JWUiLayout.h"

@interface JWScrollBar () {
    UIImageView* mBackground;
    UIImageView* mBar;
    CGFloat mPosition;
}

@end

@implementation JWScrollBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupView];
    }
    return self;
}

- (void) setupView {
    mBackground = [[UIImageView alloc] init];
    mBackground.layoutParams.width = JWLayoutWrapContent;
    mBackground.layoutParams.height = JWLayoutWrapContent;
    mBackground.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    [self addSubview:mBackground];
    
    mBar = [[UIImageView alloc] init];
    mBar.layoutParams.width = JWLayoutWrapContent;
    mBar.layoutParams.height = JWLayoutWrapContent;
    mBar.layoutParams.alignment = JWLayoutAlignCenterHorizontal | JWLayoutAlignParentTop;
    [self addSubview:mBar];
}

- (CGFloat)position {
    return mPosition;
}

- (void)setPosition:(CGFloat)position {
    if (position < 0.0f) {
        position = 0.0f;
    } else if (position > 1.0f) {
        position = 1.0f;
    }
    CGFloat backgroundLength = mBackground.frame.size.height;
    CGFloat barLength = mBar.frame.size.height;
    CGFloat scrollLength = backgroundLength - barLength;
    CGFloat scrollPosition = position * scrollLength;
//    mBar.center = CGPointMake(mBar.center.x, barLength * 0.5f + scrollPosition);
    mBar.layoutParams.marginTop = scrollPosition;
    mPosition = position;
}

- (UIImage *)backgroundImage {
    return mBackground.image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    mBackground.image = backgroundImage;
}

- (UIImage *)barImage {
    return mBar.image;
}

- (void)setBarImage:(UIImage *)barImage {
    mBar.image = barImage;
}

@end
