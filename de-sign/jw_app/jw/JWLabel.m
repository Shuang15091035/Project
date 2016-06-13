//
//  JWLabel.m
//  jw_app
//
//  Created by ddeyes on 16/4/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWLabel.h"
#import "UIView+JWUiCategory.h"
#import "UIView+JWUiLayout.h"
#import "UILabel+JWUiCategory.h"

@interface JWLabel () {
    UILabel* mLabel;
}

@end

@implementation JWLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (void) setup {
    mLabel = [[UILabel alloc] init];
    mLabel.layoutParams.width = JWLayoutWrapContent;
    mLabel.layoutParams.height = JWLayoutWrapContent;
    mLabel.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [self addSubview:mLabel];
}

- (NSString *)text {
    return mLabel.text;
}

- (void)setText:(NSString *)text {
    mLabel.text = text;
}

- (CGFloat)textSize {
    return mLabel.labelTextSize;
}

- (void)setTextSize:(CGFloat)textSize {
    mLabel.labelTextSize = textSize;
}

- (UIColor *)textColor {
    return mLabel.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    mLabel.textColor = textColor;
}

- (NSTextAlignment)textAlignment {
    return mLabel.textAlignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    mLabel.textAlignment = textAlignment;
}

- (UIFont *)font {
    return mLabel.font;
}

- (void)setFont:(UIFont *)font {
    mLabel.font = font;
}

- (void)fitTextWithOptions:(JWUiFitOptions)options {
    [mLabel fitTextWithOptions:options];
    self.frameSize = mLabel.frameSize;
}

@end
